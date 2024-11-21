#!/bin/bash

# Diretório contendo os arquivos YAML
DIRECTORY="./manifests"

# Verifica se o diretório existe
if [ ! -d "$DIRECTORY" ]; then
  echo "Diretório $DIRECTORY não encontrado. Interrompendo o script."
  exit 1
fi

# Lista e aplica os arquivos YAML no diretório em ordem alfabética
for file in "$DIRECTORY"/*.yml; do
  if [ -f "$file" ]; then
    echo "Realizando deploy de: $file"
    kubectl apply -f "$file"

    if [ $? -eq 0 ]; then
      echo "Deploy de $file realizado com sucesso!"
      echo ""
    else
      echo "Erro ao realizar deploy de $file. Interrompendo o script."
      echo ""
      exit 1
    fi
  else
    echo "Nenhum arquivo YAML encontrado em $DIRECTORY."
    echo ""
    exit 1
  fi
sleep 20
done

echo "Deploy concluído com sucesso!"
