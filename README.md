# Objetivo
Este projeto tem como objetivo realizar o deploy da do jogo guess-game, anteriormente realizado via docker-compose, mas neste momento através de manifestos kubernetes em um cluster minikube, como atividade prática da disciplina de orquestração.

***

# Requisitos

1. Possuir o minikube instalado. Documentação do [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download). 
2. Ter o kubectl instalado em sua máquina. Documentação do [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
3. Ter o GIT instalado. Documentação do [Git](https://git-scm.com/downloads/linux)
***

# Procedimento para deploy da aplicação completa

## inicialização do minikube

Após a instalação do minikube ter sido finalizada, devemos iniciá-lo com o seguinte comando:

```
minikube start
```

Após finalizar o comando, verificar se o node está ready:

```
kubectl get nodes
```

A saída deve ser similar a esta:

```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   92m   v1.31.0
```

Com isso o minikube está pronto para ser utilizado.

## Preparação do ambiente


Antes de iniciarmos o deploy, devemos realizar algumas modificações na instalação padrão do minikube, que consiste na instalação de dois addons para pleno funcionamento do jogo. A primeira alteração será a instalação do addon referente ao [**ingress**](https://kubernetes.io/docs/concepts/services-networking/ingress/), e a segunda será referente ao **metrics-server** que é necessário para a utilização do [**HPA**](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/).

A instalação dos dois addons é realizada com os seguintes comandos:

```
minikube addons enable ingress
minikube addons enable metrics-server
```

Após a instalação de ambos, podemos verificar conforme a saída do comando abaixo:

```
minikube addons list
```

que resultará na saída:

```
|-----------------------------|----------|--------------|--------------------------------|
|         ADDON NAME          | PROFILE  |    STATUS    |           MAINTAINER           |
|-----------------------------|----------|--------------|--------------------------------|
| ambassador                  | minikube | disabled     | 3rd party (Ambassador)         |
| auto-pause                  | minikube | disabled     | minikube                       |
| cloud-spanner               | minikube | disabled     | Google                         |
| csi-hostpath-driver         | minikube | disabled     | Kubernetes                     |
| dashboard                   | minikube | disabled     | Kubernetes                     |
| default-storageclass        | minikube | enabled ✅   | Kubernetes                     |
| efk                         | minikube | disabled     | 3rd party (Elastic)            |
| freshpod                    | minikube | disabled     | Google                         |
| gcp-auth                    | minikube | disabled     | Google                         |
| gvisor                      | minikube | disabled     | minikube                       |
| headlamp                    | minikube | disabled     | 3rd party (kinvolk.io)         |
| helm-tiller                 | minikube | disabled     | 3rd party (Helm)               |
| inaccel                     | minikube | disabled     | 3rd party (InAccel             |
|                             |          |              | [info@inaccel.com])            |
| ingress                     | minikube | enabled ✅   | Kubernetes                     |
| ingress-dns                 | minikube | disabled     | minikube                       |
| inspektor-gadget            | minikube | disabled     | 3rd party                      |
|                             |          |              | (inspektor-gadget.io)          |
| istio                       | minikube | disabled     | 3rd party (Istio)              |
| istio-provisioner           | minikube | disabled     | 3rd party (Istio)              |
| kong                        | minikube | disabled     | 3rd party (Kong HQ)            |
| kubeflow                    | minikube | disabled     | 3rd party                      |
| kubevirt                    | minikube | disabled     | 3rd party (KubeVirt)           |
| logviewer                   | minikube | disabled     | 3rd party (unknown)            |
| metallb                     | minikube | disabled     | 3rd party (MetalLB)            |
| metrics-server              | minikube | enabled ✅   | Kubernetes                     |
| nvidia-device-plugin        | minikube | disabled     | 3rd party (NVIDIA)             |
| nvidia-driver-installer     | minikube | disabled     | 3rd party (NVIDIA)             |
| nvidia-gpu-device-plugin    | minikube | disabled     | 3rd party (NVIDIA)             |
| olm                         | minikube | disabled     | 3rd party (Operator Framework) |
| pod-security-policy         | minikube | disabled     | 3rd party (unknown)            |
| portainer                   | minikube | disabled     | 3rd party (Portainer.io)       |
| registry                    | minikube | disabled     | minikube                       |
| registry-aliases            | minikube | disabled     | 3rd party (unknown)            |
| registry-creds              | minikube | disabled     | 3rd party (UPMC Enterprises)   |
| storage-provisioner         | minikube | enabled ✅   | minikube                       |
| storage-provisioner-gluster | minikube | disabled     | 3rd party (Gluster)            |
| storage-provisioner-rancher | minikube | disabled     | 3rd party (Rancher)            |
| volcano                     | minikube | disabled     | third-party (volcano)          |
| volumesnapshots             | minikube | disabled     | Kubernetes                     |
| yakd                        | minikube | disabled     | 3rd party (marcnuri.com)       |
|-----------------------------|----------|--------------|--------------------------------|
```

Após estes procedimentos, realizaremos, de fato, o deploy da aplicação.

***

## Deploy da aplicação

Realizar o clone da aplicação no repositorio, com o comando abaixo:

```
git clone https://github.com/akajcn/pratica-k8s-akajcn.git
```

Após realizar o clone, entrar no diretório recém clonado:

```
cd pratica-k8s-akajcn
```

Antes de realizar a execução do script para deploy, devemos criar o namespace manualmente. Este namespace será exclusivo para o projeto e nele estarão os recursos para o funcionamento do jogo.

```
kubectl create ns ns-guess
```

Dentro do diretório **pratica-k8s-akajcn**, realizaremos a execução do script **up-game.sh**, da seguinte forma:

```
./up-game.sh
```

Após a execução do script, deverá ser apresentada uma saída como esta:

```
Realizando deploy de: ./manifests/1-postgres.yml
storageclass.storage.k8s.io/sc-postgres unchanged
persistentvolume/pv-postgres unchanged
persistentvolumeclaim/pvc-postgres created
secret/secret-postgres created
deployment.apps/deploy-postgres created
service/svc-postgres created
Deploy de ./manifests/1-postgres.yml realizado com sucesso!

Realizando deploy de: ./manifests/2-backend.yml
configmap/cm-backend created
secret/secret-backend created
deployment.apps/guess-backend created
service/svc-backend created
horizontalpodautoscaler.autoscaling/hpa-backend created
Deploy de ./manifests/2-backend.yml realizado com sucesso!

Realizando deploy de: ./manifests/3-frontend.yml
configmap/cm-frontend created
deployment.apps/guess-frontend created
service/svc-frontend created
Deploy de ./manifests/3-frontend.yml realizado com sucesso!

Realizando deploy de: ./manifests/4-ingress.yml
ingress.networking.k8s.io/ingress-guess created
Deploy de ./manifests/4-ingress.yml realizado com sucesso!

Deploy concluído com sucesso!
```

Para verificar os recursos foram criados, executaremos o seguinte comando:

```
kubectl get all,ingress -n ns-guess
```

A saída será semelhante a esta:

```
NAME                                  READY   STATUS    RESTARTS   AGE
pod/deploy-postgres-fc9bb9b77-mc7ft   1/1     Running   0          2m58s
pod/guess-backend-5477f78fb5-bj8ww    1/1     Running   0          2m48s
pod/guess-frontend-64d9c848c5-wmfm6   1/1     Running   0          2m38s

NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/svc-backend    ClusterIP   10.101.122.141   <none>        5000/TCP   2m48s
service/svc-frontend   ClusterIP   10.110.195.65    <none>        3000/TCP   2m38s
service/svc-postgres   ClusterIP   10.96.229.16     <none>        5432/TCP   2m58s

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/deploy-postgres   1/1     1            1           2m58s
deployment.apps/guess-backend     1/1     1            1           2m48s
deployment.apps/guess-frontend    1/1     1            1           2m38s

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/deploy-postgres-fc9bb9b77   1         1         1       2m58s
replicaset.apps/guess-backend-5477f78fb5    1         1         1       2m48s
replicaset.apps/guess-frontend-64d9c848c5   1         1         1       2m38s

NAME                                              REFERENCE                  TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/hpa-backend   Deployment/guess-backend   cpu: 0%/50%   1         3         1          2m48s

NAME                                      CLASS   HOSTS                 ADDRESS        PORTS   AGE
ingress.networking.k8s.io/ingress-guess   nginx   game.guess-game.com   192.168.49.2   80      2m27s
```

Com isso, o deploy foi realizado com sucesso!

***
## Acessando a aplicação

Antes de acessar o jogo, devemos realizar uma alteração em nosso sistema operacional no arquivo **/etc/hosts**

Para inserir o ip do minikube no arquivo em questão, utilizaremos o seguinte comando (sendo necessario utilizar senha com permissão root):

```
echo "$(minikube ip) game.guess-game.com" | sudo tee -a /etc/hosts
```
Para verificar se o conteúdo acima foi adicionado, executamos o seguinte comando:

```
cat /etc/hosts
```

Devemos ter uma saída similar a esta:

```
127.0.0.1 localhost
127.0.1.1 valinor
192.168.49.2    game.guess-game.com
# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
Após estes passos, abrimos o navegador e digitamos a seguinte URL:

```
http://game.guess-game.com
```

Após isso, a aplicação deve estar acessivel!

***

## Removendo o deploy

Para remover o deploy, dentro do diretório **pratica-k8s-akajcn**, executar o seguinte comando:

```
kubectl delete -f manifests/
```

Após isso, deletar o namespace criado para o projeto:

```
kubectl delete ns ns-guess
```