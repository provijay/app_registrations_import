Create a working folder, e.g. C:\projects\entra-tf and put these files inside:

0-prereqs-and-vars.ps1 — variables you must edit

1-export-entraid.ps1 — exports apps + sps + owners to JSON

2-generate-tf.ps1 — generates TF files & mapping CSV

backend.tf — sample backend configuration (edit)

provider.tf — provider blocks

3-import-batch.ps1 — batch import into terraform state with retries

4-reconcile.ps1 — compare exported JSON vs terraform state and create diff report

modules/app/main.tf — optional small module (generator will reference direct resources; this file is optional)

I’ll give the full content for each file below. Copy each into the files above.




How to run the pipeline (order of execution)

1. Edit 0-prereqs-and-vars.ps1 and backend.tf to match your environment (backend container, storage account, resource group). Save files.

2. Open PowerShell 7+ in the working directory.

3. .\1-export-entraid.ps1 — exports apps & sps to exports\*.json.

4. .\2-generate-tf.ps1 — generates TF files under generated\ and a mapping.csv.

5. Copy or move generated\*.tf files into your Terraform root (or adjust structure). Alternatively set Terraform root to the generated folder and also include backend.tf + provider.tf there.

6. terraform init in Terraform root (or run .\3-import-batch.ps1, which runs terraform init automatically).

7. .\3-import-batch.ps1 — imports all apps and SPs in mapping.csv into state.

8. terraform plan — inspect planned changes. If there are diffs, adjust generated .tf to match provider representations, or add lifecycle { ignore_changes = [...] } for provider-computed fields you do not want to manage. Iterate until terraform plan shows no changes.

9. .\4-reconcile.ps1 — run reconcile and inspect reconcile-report.csv for mismatches.
