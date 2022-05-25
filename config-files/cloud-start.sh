#!/usr/bin/env bash

# Este script deve ser usado para preparar e executar o WebProxy após configurar o arquivo .env
# Referência: https://github.com/evertramos/nginx-proxy-automation

# 1. Verifique se o arquivo .env existe
if [ -e .env ]; then
    echo ".env file found, sourcing contents..."
    source .env
else 
    echo 
    echo "Por favor, configure seu arquivo .env antes de iniciar seu ambiente de Cloud."
    echo 
    exit 1
fi

# 2. Copie os arquivos de configuração

if [ -w ${PATH_NEXTCLOUD} ]; then 
    echo "${PATH_NEXTCLOUD} é gravável pelo usuário. Copiando arquivos de configuração..."
    mkdir -p ${PATH_NEXTCLOUD}/config
    cp ./config-files/nextcloud-web/nginx.conf ${PATH_NEXTCLOUD}/config/
else
    echo "'${PATH_NEXTCLOUD}' não é gravável pelo usuário. Copiando arquivos de configuração com sudo..."
    sudo mkdir -p ${PATH_NEXTCLOUD}/config
    sudo cp ./config-files/nextcloud-web/nginx.conf ${PATH_NEXTCLOUD}/config/
fi

# 2.1 Caso tenha ocorrido algum erro informa ao usuário
if [ $? -ne 0 ]; then
    echo
    echo "############################################################"
    echo
    echo  "Ocorreu um erro ao tentar copiar os arquivos conf do nginx."
    echo  "Não foi possível continuar, parando... "
    echo 
    echo "############################################################"
    exit 1
fi

# 3. Verifique se o usuário está configurado para usar arquivos de configuração especiais
if [ ! -z ${USE_NGINX_CONF_FILES+X} ] && [ "$USE_NGINX_CONF_FILES" = true ]; then

    if [ -w ${NGINX_PROXY_PATH} ]; then
        echo "'${NGINX_PROXY_PATH}' é gravável pelo usuário. Copiando arquivos de configuração..."
        mkdir -p ${NGINX_PROXY_PATH}/conf.d
        # Copy the special configurations to the nginx conf folder
        cp -R ./config-files/nginx-proxy-conf.d/*.conf $NGINX_PROXY_PATH/conf.d
    else
        echo "'${NGINX_PROXY_PATH}' não é gravável pelo usuário. Copiando arquivos de configuração com sudo..."
        sudo mkdir -p ${NGINX_PROXY_PATH}/conf.d
        sudo cp -R ./config-files/nginx-proxy-conf.d/*.conf $NGINX_PROXY_PATH/conf.d
    fi

    # 3.1 Caso tenha ocorrido algum erro informa ao usuário
    if [ $? -ne 0 ]; then
        echo
        echo "########################################################################"
        echo
        echo "Ocorreu um erro ao tentar copiar os arquivos conf do nginx. "
        echo "O proxy ainda funcionará com as opções padrão, mas "
        echo "as configurações personalizadas que você fez não puderam ser carregadas. "
        echo 
        echo "########################################################################"
    fi
fi 

# 4. Cria uma rede proxy
docker network create ${PREFIX_INSTANCE}-proxy-network $PROXY_NETWORK_OPTIONS

# 5. Cria a rede nextcloud
docker network create ${PREFIX_INSTANCE}-nextcloud-network $NEXTCLOUD_NETWORK_OPTIONS

# 6. Realiza login da conta Docker Hub
#echo ${DOCKER_HUB_PASS} | docker login --username ${DOCKER_HUB_USER} --password-stdin

# 7. Atualiza imagens locais
#docker-compose pull

# 8. Sobe tudo
docker-compose up -d

exit 0