# Objetivo
Este projeto tem como objetivo realizar o deploy da do jogo guess-game, anteriormente realizado via docker-compose, mas neste momento através de manifestos kubernetes em um cluster minikube, como atividade prática da disciplina de orquestração.

***

# Requisitos

1. Possuir o minikube instalado. Documentação do [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download). 
2. Ter o kubectl instalado em sua máquina. Documentação do [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

***

# Procedimento para deploy da aplicação completa

## inicialização do minikube

Após a instalação do minikube ter sido finalizada, devemos iniciá-lo com o seguinte comando:

```minikube start```

Após finalizar o comando, verificar se o node está ready:

```kubectl get nodes```

A saída deve ser similar a esta:

```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   92m   v1.31.0
```

Com isso o minikube está pronto para ser utilizado.

## Deploy da aplicação

Realizar o clone da aplicação no

