## Terraform documentation

### Let's start with the principals commands:

 Find the terraform version: 
```terraform version ```

Switch the working directory:
``` terraform -chdir=<path_to/tf> <subcommand>```

Initalize the directory:
```terraform init```

Crete an execution plan:
```terraform plan```

Apply changes:
```terraform apply```

Destroy the managed infraestructure:
```terraform destroy```

### Now let's expand this commans upon

Plan, Deploy and Cleanup Commands

Output a deployment plan, for example when you create a directory and want to put the plan in a file:
```terraform plan -out <plan_name>```

Output a destroy plan:
```terraform plan -destroy```

Apply a specifc plan:
```terraform apply <plan_name>```

Only apply changes to a target resource:
```terraform apply -target=<resource_name>```

Pass a variable via the command line
```terraform apply -var my_variable=<variable>```

Get provider info used in configuration
```terraform providers```

```
A terraform sytax consists of:
'Blocks' -> are containers for objects like resources
'Arguments' -> assign a value to a plan name
'Expressions' -> represent a value 

```