# Instalação

Estas instruções assumem que o software irá ser executado num computador Raspberry Pi em conjunto com OctoPrint. É recomendado que seja usado um Raspberry Pi 2, 3 ou 4 como host (verificar [FAQ](FAQ.md#posso-correr-klipper-sem-ser-num-Raspberry-Pi-3) para outras máquinas).

## Obter um arquivo de configuração do Klipper

A maioria das configurações do Klipper são determinadas por um arquivo de configuração da impressora que será armazenado na Raspberry Pi. Um arquivo de configuração apropriado pode ser encontrado procurando no diretório [config](../config/) do Klipper por um arquivo que comece com um prefixo "printer-" que corresponda à impressora. O arquivo de configuração do Klipper contém informações sobre a impressora que serão necessárias durante a instalação.

Se não houver um arquivo de configuração de impressora apropriado no diretório do Klipper, tente pesquisar no site do fabricante da impressora para ver se existe algum arquivo de configuração apropriado.

Se nenhum arquivo de configuração adequado puder ser encontrado, mas o tipo de placa de controle da impressora for conhecido, então procure por um [config file](../config/) apropriado começando com um prefixo "generic-". Esses arquivos de exemplo devem permitir que se conclua com sucesso a instalação inicial, mas exigirão alguma personalização para obter o funcionamento completa da impressora.

Também é possível definir uma nova configuração do zero. No entanto, isso requer conhecimento técnico sobre a impressora e seus componentes eletrônicos. É recomendado que a maioria dos usuários comece com um arquivo de configuração apropriado. Se estiver criando um novo arquivo de configuração personalizado, comece com o exemplo mais próximo [config file](../config/) e use a [config reference](Config_Reference.md) do Klipper para obter informações.

## Preparando imagem do SO

Comece instalando o [OctoPi](https://github.com/guysoft/OctoPi) no Raspberry Pi. Use o OctoPi v0.17.0 ou posterior - veja [OctoPi releases](https://github.com/guysoft/OctoPi/releases) para obter informações sobre a versão. Verifique se o OctoPi inicia e se o servidor web do OctoPrint funciona. Após conectar-se à página do OctoPrint, siga o prompt para atualizar o OctoPrint para a v1.4.2 ou superior.

Depois de instalar o OctoPi e atualizar o OctoPrint, é necessário ligar-se à máquina usando ssh para executar alguns comandos de sistema. Usando um computador Linux ou MacOS, então o software para "ssh" já deverá estar instalado. Há alguns outros clientes ssh disponíveis para outros computadores (ex, [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)). Use a ferramenta ssh para se conectar ao Raspberry Pi (ssh pi@octopi --password is "raspberry") e corra os seguintes comandos:

```
git clone https://github.com/Klipper3d/klipper
./klipper/scripts/install-octopi.sh
```

Acima fará o download do Klipper, instalará algumas dependências do sistema, configurará o Klipper para iniciar na inicialização do sistema e iniciará o software do Klipper. Será necessária uma conexão com a internet e pode levar alguns minutos pra ser concluído.

## Configurando e atualizando o microcontrolador

Para compilar o código do microcontrolador, comece executando estes comandos na Raspberry Pi:

```
cd ~/klipper/
make menuconfig
```

Os comentários no topo de [printer configuration file](#obtain-a-klipper-configuration-file) deve descrever o que deve ser configurado durante "make menuconfig". Abra o arquivo em um navegador/editor e procure por estas instruções perto do topo do arquivo. Depois de ajustar tudo com "menuconfig", pressione "Q" para sair e, em seguida, "Y" para salvar. Em seguida, execute:

```
make
```

Se os comentários na parte superior do [printer configuration file](#obtain-a-klipper-configuration-file) descreverem etapas personalizadas para "transmitir" a imagem final para a placa controladora, siga essas etapas e prossiga para [configuring OctoPrint](#configuring-octoprint-to-use-klipper).

Caso contrário, as etapas a seguir são frequentemente usadas para atualizar (flash) a placa controladora. Primeiro, é necessário determinar a porta serial conectada ao microcontrolador. Execute o seguinte:

```
ls /dev/serial/by-id/*
```

Deve relatar algo semelhante ao exemplo:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

É comum que cada impressora tenha seu próprio nome de porta serial exclusivo. Esse nome exclusivo será usado ao atualizar o microcontrolador. É possível que haja várias linhas no output acima - se houver, escolha a linha correspondente ao microcontrolador (veja o [FAQ](FAQ.md#wheres-my-serial-port) para mais informações).

Para microcontroladores comuns, o código pode ser atualizado com algo semelhante a:

```
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
sudo service klipper start
```

Certifique-se de atualizar o FLASH_DEVICE com o nome exclusivo da porta serial da impressora.

Ao atualizar (realizar um flash) pela primeira vez, certifique-se de que o OctoPrint não está conectado diretamente à impressora (na página da web do OctoPrint, na seção "Conexão" ("Connection"), clique em "Desconectar" ("Disconnect")).

## Configurando o OctoPrint com o Klipper

O servidor web OctoPrint precisa ser configurado para se comunicar com o Klipper. Usando um navegador, faça login na página do OctoPrint e então configure os seguintes itens:

Navegue até a aba Configurações. Em "Conexão serial" ("Serial Connection") em "Portas seriais adicionais" (""Additional serial ports""), adicione "/tmp/printer". Então clique em "Salvar" ("Save").

Entre na aba Configurações novamente e em "Conexão serial" (Serial Connection), e altere a configuração de Porta serial para "/tmp/printer".

Na aba de Configurações, navegue até "Comportamento" (Behavior) e selecione a opção "Cancelar quaisquer impressões em andamento, mas permanecer conectado à impressora" (Cancel any ongoing prints but stay connected to the printer). Depois, clique em salvar.

Na página principal, na seção "Conexão" (Connection) (no canto superior esquerdo da página), certifique-se de que a Porta serial esteja definida como "/tmp/printer" e clique em "Conectar" (Connect). (Se "/tmp/printer" não for uma opção disponível, tente recarregar a página.)

Uma vez conectado, navegue até a aba "Terminal" e digite "status" (sem aspas) na caixa de entrada de comando e clique para enviar. A janela do terminal provavelmente informará que há um erro ao abrir o arquivo de configuração - isso significa que o OctoPrint está se comunicando com o Klipper. Prossiga para a próxima seção.

## Configurando Klipper

O próximo passo é copiar o [printer configuration file](#obtain-a-klipper-configuration-file) para a Raspberry Pi.

Provavelmente a maneira mais fácil de definir o arquivo de configuração do Klipper é usar um editor que suporte a edição de arquivos pelos protocolos "scp" e/ou "sftp". Existem ferramentas disponíveis gratuitamente que suportam isso (por exemplo, Notepad++, WinSCP e Cyberduck). Carregue o arquivo de configuração no editor e salve-o como um arquivo chamado "printer.cfg" no diretório home do usuário pi (ou seja, /home/pi/printer.cfg).

Também é possível copiar e editar o arquivo diretamente no Raspberry Pi via SSH. Isso pode parecer algo como (certifique-se de atualizar o comando para usar o nome de arquivo de configuração apropriado):

```
cp ~/klipper/config/example-cartesian.cfg ~/printer.cfg
nano ~/printer.cfg
```

É comum que cada impressora tenha seu próprio nome exclusivo para o microcontrolador. O nome pode mudar após o flash do Klipper, então execute novamente essas etapas mesmo que elas já tenham sido feitas. Execute:

```
ls /dev/serial/by-id/*
```

Deve relatar algo semelhante ao exemplo:

```
/dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Após, atualize o arquivo de configuração com o nome adequado. Por exemplo, atualize a seção `[mcu]` para algo parecido com:

```
[mcu]
serial: /dev/serial/by-id/usb-1a86_USB2.0-Serial-if00-port0
```

Após criar e editar o arquivo, será necessário emitir um comando "restart" no terminal do OctoPrint para funcionar. Um comando "status" informará que a impressora está pronta se o arquivo de configuração do Klipper for lido com sucesso e o microcontrolador for encontrado e configurado.

Ao personalizar o arquivo de configuração, não é incomum que o Klipper relate um erro. Se ocorrer, faça as correções necessárias no arquivo e execute "restart" até que "status" informe que a impressora está pronta.

O Klipper relata mensagens de erro por meio do terminal do OctoPrint. O comando "status" pode ser usado para relatar mensagens de erro. O script de inicialização padrão do Klipper também coloca um log em **/tmp/klippy.log** que fornece mais informações.

Após o Klipper relatar que a impressora está pronta, prossiga para o [config check document](Config_checks.md) para executar algumas verificações básicas no arquivo de configuração. Veja [documentation reference](Overview.md) para outras informações.
