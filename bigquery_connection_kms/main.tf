resource "google_bigquery_connection" "connection" {
   connection_id = "my-connection-${local.name_suffix}"
   location      = "aws-us-east-1"
   friendly_name = "👋"
   description   = "a riveting description"
   kms_key_name  = "kms-key-${local.name_suffix}"
   aws { 
      access_role {
         iam_role_id =  "arn:aws:iam::999999999999:role/omnirole-${local.name_suffix}"
      }
   }

  depends_on = [
    google_kms_crypto_key_iam_member.crypto_key
  ]
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
   crypto_key_id = "kms-key-${local.name_suffix}"
   role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
   member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
 }
 
 data "google_project" "project" {}
