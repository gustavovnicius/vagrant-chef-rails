Bem, vamos lá.

Atualmente, este repositório está com a configuração básica para uma VM com projeto Rails v4.0.2, Ruby 2.1.0 e MySQL.

Vamos começar configurando o Vagrantfile:

Instale primeiramente os plugins do omnibus e aws

### vagrant plugin install vagrant-aws
### vagrant plugin install vagrant-omnibus

#### Desenvolvimento

### dev.vm.hostname = ''
### dev.vm.network :private_network, ip: ''
Coloque o nome do host e IP da VM.

## chef.json
Sinta-se à vontade para alterar (Host que o nginx vai servir e o nome do arquivo de configuração):
### nginx_host: 'dev.nome_do_projeto.com.br' 
Pode ser o endereço IP
### nginx_conf_name: 'conf_default'

Não esqueça de colocar no /etc/hosts!!

#### Importante
Gere uma chave ssh com o comando 
### ssh-keygen 
e coloque na pasta
### /chef/cookbooks/default/files/default 
Os arquivos devem chamar 
### id_rsa 
e 
### id_rsa.pub
Essas chaves serão importantes para quando formos configurar o deploy.

Após isso, vamos configurar o Chef.

#### Chef
Por enquanto, não precisa fazer nada :)

No root do projeto, dê um vagrant up e aguarde.

#### Homologação
Informe os dados para permitir ao plugin acessar a API da Amazon e subir as instâncias:

### aws.access_key_id = ""
### aws.secret_access_key = ""
### aws.keypair_name = ""

### aws.region
Informe a região

### aws.ami
Retire o comentário da ami correspondente à região que irá usar 

### aws.keypair_name
Selecione o keypair que a instância irá utilizar (ele deve ser criado na região selecionada)

### override.ssh.private_key_path
Coloque o caminho onde está o .pem para a instância. Normalmente colocamos em uma pasta chamada aws_keys, no projeto. Se for o caso, basta substituir as aspas em branco pelo nome do arquivo

## chef.json
unicorn: { rails_path: } #Coloque o caminho do projeto. Por padrão, apenas substitua as aspas em branco pelo nome do seu projeto. Deve ser o mesmo caminho que o capistrano usará para fazer deploy.

Mesma coisa que foi feita em DEV para o nginx_host e nginx_conf_name