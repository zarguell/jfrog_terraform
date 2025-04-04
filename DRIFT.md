No, the provided Terraform script **only ensures** that the specified repositories exist, but it does **not** delete or manage other repositories that may have been created manually or outside of Terraform.  

### How to Ensure Only These Repositories Exist  
If you want to **enforce that only these repositories exist** and delete any others, you have a few options:

#### **1. Use Terraform Import & Management**  
Terraform only manages resources it creates. If there are existing repositories in Artifactory, you can import them into Terraform using:  
```sh
terraform import artifactory_remote_repository.existing_repo existing-repo-key
```
Once imported, you can **remove unwanted repositories** by deleting their definitions from the `.tf` file and running:  
```sh
terraform apply
```
Terraform will then remove them from Artifactory.

#### **2. Use a "Destroy All Unmanaged" Approach**  
You can query all existing repositories using the Artifactory API and compare them against your Terraform-defined ones. Any repos not in Terraform can then be **manually deleted** or deleted via a script.

Example API call to list existing repositories:
```sh
curl -u user:password -X GET "https://your-artifactory-instance.com/artifactory/api/repositories"
```
Then, compare the results with your Terraform configuration and delete those not defined.

#### **3. Use Terraform's `-replace` or `-destroy`**  
If you suspect drift (manual changes outside Terraform), you can force Terraform to reset everything:
```sh
terraform apply -replace=artifactory_remote_repository.repo_name
```
Or destroy and re-apply:
```sh
terraform destroy && terraform apply
```

### **Final Thoughts**  
Terraform doesn’t automatically delete unmanaged resources, so if you need **strict control**, you’ll need to either:
1. Import and manage all existing repos in Terraform.
2. Periodically check for unauthorized repos and remove them manually.
3. Use a separate script to enforce repository policies.

Would you like help automating the enforcement process? 🚀