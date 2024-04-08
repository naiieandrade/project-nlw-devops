## sobre

Projeto de Devops da NLW Unite, ministrando as aulas o Daniel Rodrigues da Silva (tech lead na flash <linkedin>)

## TODO

- [ ] Hoje para o migrations funcionar preciso acessar o container da API e rodar `npm run db:migrate`. Ver como arrumar isso.

- [ ] Templetizar os arquivos secret e configmap em deploy/templates





## Argocd

```
sudo kubectl port-forward svc/argocd-server -n argocd 3001:80
```
rodando no localhost:3001

```
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```




![alt text](argo1.png)


Dentro da pasta de deploy.cross 
```
sudo kubectl apply -n argocd -f apps/passin
```

Nesse comando aqui acima eu precisei apagar e subir o comando de novo até ele pegar o path correto e sincronizar corretamente como na imagem abaixo:
![alt text](argo2.png)

para ver o deploy rodando:
```
kubectl get pods -n nlw
```
para ver onde está rodando/nome da aplicação
```
sudo kubectl get svc -n nlw
```

e depois o port forward para..?

```
sudo kubectl port-forward svc/nlw-passin-deploy -n nlw 3333:80
```

e em localhost:3333/docs, vai estar rodando a app:

![alt text](image.png)

