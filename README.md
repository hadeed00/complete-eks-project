# **This Project currently has actions disabled**

This project builds a flask app in python and I used Docker to create an image for it.

This image was used to create a flask-app helm chart.

The terraform builds an EKS Cluster.

The Terraform uses the helm chart to create the flask app.

The Terraform also creates an Ingress NGINX chart which is used for the flask app.

The above is all built simply from going to the GitHub Actions tab and running the pipeline (tfstate stored in s3 bucket).

To test everything has worked from my local terminal I simply run the following commands:

```
aws eks --region eu-west-2 update-kubeconfig --name flask-eks-project

kubectl get ingresses -A

curl <Ingress.Address>/health
 
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Which should return a status code of 200 for a healthy response.