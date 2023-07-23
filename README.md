kubernetes-action : Fix for the recent change in awscli package that removes support for Python 2.7 
=============
Interacts with kubernetes clusters calling `kubectl` commands. Integrates support for **AWS EKS**.

### Kubectl version = v1.27.1

If you are getting the below issue - 
```
error: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"
```
Update that line/value in your .kube/config file to this - 
```
client.authentication.k8s.io/v1beta1
```

Then base64 encode it again and update your secret in GitHub. 

## Usage

### Basic Example

```yml
name: CI

on:
  - push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Trigger deploy
        uses: davi020/kubernetes-action@master
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        with:
          args: apply deployment.yaml
```

### EKS Example
```yml
name: CI

on:
  - push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Trigger deploy
        uses: davi020/kubernetes-action@master
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        with:
          args: apply deployment.yaml
```

## Config

### Secrets

One or more **secrets** needs to be created to store cluster credentials. (see [here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets) for help on creating secrets). 

#### Basic
- **KUBE_CONFIG_DATA**: A `base64` representation of `~/.kube/config` file.

##### Example
```bash
cat ~/.kube/config | base64 | pbcopy # pbcopy will copy the secret to the clipboard (Mac OSX only)
```

#### EKS
- **KUBE_CONFIG_DATA**: Same as Basic configuration above.

- **AWS_ACCESS_KEY_ID**: AWS_ACCESS_KEY_ID of a IAM user with permissions to access the cluster.

- **AWS_SECRET_ACCESS_KEY**: AWS_SECRET_ACCESS_KEY of a IAM user with permissions to access the cluster.

Make sure your users has the proper IAM permissions to access your cluster and that its configured inside kubernetes (more info [here](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html)).

## Outputs

- **result**: Output of the `kubectl` command.

### Example
```yaml
      - name: Save container image
        id: image-save
        uses: davi020/kubernetes-action@master
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        with:
          args: get deploy foo -o jsonpath="{..image}"

      - name: Print image
        run: 
          echo ${{ steps.image-save.outputs.result }}
```

More info on how to use outputs [here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/metadata-syntax-for-github-actions#outputs).
