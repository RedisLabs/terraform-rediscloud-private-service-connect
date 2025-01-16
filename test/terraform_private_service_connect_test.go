package test

import (
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	testStructure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const expectNumberOfServiceAttachments = 40

func TestTerraformPrivateServiceConnect(t *testing.T) {
	gcpProject := os.Getenv("GCP_PROJECT_ID")
	tc := []struct {
		testModule             string
		expectedMap            bool
		expectedDNSRecordKeys  []string
		expectedDNSRecordCount int
	}{
		{
			testModule:            "../examples/active_active",
			expectedMap:           true,
			expectedDNSRecordKeys: []string{"us-central1", "europe-west1"},
		},
		{
			testModule:             "../examples/pro",
			expectedDNSRecordCount: 1,
		},
	}

	for _, tt := range tc {
		t.Run(tt.testModule, func(t *testing.T) {
			t.Parallel()

			defer testStructure.RunTestStage(t, "destroy", func() {
				terraformOptions := testStructure.LoadTerraformOptions(t, tt.testModule)
				terraform.Destroy(t, terraformOptions)
			})

			testStructure.RunTestStage(t, "configure", func() {
				prefix := fmt.Sprintf("tfm-test-%s", strings.ToLower(random.UniqueId()))

				terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
					TerraformDir: tt.testModule,
					Vars: map[string]interface{}{
						"prefix":         prefix,
						"gcp_project_id": gcpProject,
					},
				})

				testStructure.SaveTerraformOptions(t, tt.testModule, terraformOptions)
			})

			testStructure.RunTestStage(t, "deploy", func() {
				terraformOptions := testStructure.LoadTerraformOptions(t, tt.testModule)

				terraform.InitAndApply(t, terraformOptions)
			})

			testStructure.RunTestStage(t, "validate", func() {
				terraformOptions := testStructure.LoadTerraformOptions(t, tt.testModule)
				if tt.expectedMap {
					dnsRecordsJson := terraform.OutputJson(t, terraformOptions, "redis_dns_records")
					var dnsRecords map[string][][]string
					err := json.Unmarshal([]byte(dnsRecordsJson), &dnsRecords)
					require.NoError(t, err)
					for _, key := range tt.expectedDNSRecordKeys {
						assert.Contains(t, dnsRecords, key)
					}
					for _, endpoints := range dnsRecords {
						for _, endpoint := range endpoints {
							assert.Len(t, endpoint, expectNumberOfServiceAttachments)
						}
					}
				} else {
					dnsRecordsJson := terraform.OutputJson(t, terraformOptions, "redis_dns_records")
					var dnsRecords [][]string
					err := json.Unmarshal([]byte(dnsRecordsJson), &dnsRecords)
					require.NoError(t, err)

					assert.Len(t, dnsRecords, tt.expectedDNSRecordCount)
					for _, v := range dnsRecords {
						assert.Len(t, v, expectNumberOfServiceAttachments)
					}
				}
			})
		})
	}
}
