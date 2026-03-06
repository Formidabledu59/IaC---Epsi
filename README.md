# IaC - Infrastructure as Code

Doc a suivre : https://slides.com/vm-it/iac
---

## TP-local

https://slides.com/vm-it/iac#/6/51

### Exo 1 - variables

https://slides.com/vm-it/iac#/6/60
lien util : https://developer.hashicorp.com/terraform/language/block/variable

### Exo 2 - outputs

https://slides.com/vm-it/iac#/6/61
lien util : https://developer.hashicorp.com/terraform/language/values/outputs

### Exo 3 - commande Welcom

https://slides.com/vm-it/iac#/6/62

### Exo 4 - container Docker

https://slides.com/vm-it/iac#/6/63

### Exo 5 - count

https://slides.com/vm-it/iac#/6/65

### Exo 6 - multi container Docker

https://slides.com/vm-it/iac#/6/65

### Exo 7 - eu-west-1

Outputs:

machines = tolist([
  {
    "disk_size" = 20
    "name" = "vm-1"
    "region" = "eu-west-1"
    "vcpu" = 2
  },
])

https://slides.com/vm-it/iac#/6/65

---

## Localstack - AWS

installation localstack : https://github.com/localstack/localstack?tab=readme-ov-file

```localstack -v``` LocalStack CLI 4.14.0

```localstack start``` 
```powershell
     __                     _______ __             __
    / /   ____  _________ _/ / ___// /_____ ______/ /__
   / /   / __ \/ ___/ __ `/ /\__ \/ __/ __ `/ ___/ //_/
  / /___/ /_/ / /__/ /_/ / /___/ / /_/ /_/ / /__/ ,<
 /_____/\____/\___/\__,_/_//____/\__/\__,_/\___/_/|_|

- LocalStack CLI: 4.14.0
- Profile: default
- App: https://app.localstack.cloud
```

installation AWS CLI : https://awscli.amazonaws.com/AWSCLIV2.msi

```aws --version``` aws-cli/2.34.3 Python/3.13.11 Windows/11 exe/AMD64

https://slides.com/vm-it/iac#/7/9 - 

```powershell
& { $env:AWS_ACCESS_KEY_ID = "test"; $env:AWS_SECRET_ACCESS_KEY = "test"; $env:AWS_DEFAULT_REGION = "us-east-1"; aws --endpoint-url=http://localhost:4566 s3 ls }
```

```powershell
& { $env:AWS_ACCESS_KEY_ID = "test"; $env:AWS_SECRET_ACCESS_KEY = "test"; $env:AWS_DEFAULT_REGION = "us-east-1"; aws --endpoint-url=http://localhost:4566 s3 ls s3://my-bucket }
``` 