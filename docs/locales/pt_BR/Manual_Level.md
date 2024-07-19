# Nivelamento Manual

Este documento descreve as ferramentas para calibrar o Fim de Curso (Eixo Z) e realizar ajustes nos parafusos da mesa.

## Calibrando Fim de Curso (Eixo Z)

Uma configuração precisa do fim de curso (Eixo Z) é crítica para obter impressões de alta qualidade.

Observe que a precisão da própria chave de fim de curso (Eixo Z) pode ser um fator limitante. Se estiver usando drivers de motor de passo Trinamic, considere ativar a detecção de [endstop phase](Endstop_Phase.md) para melhorar a precisão.

Para calibrar o fim de curso (Eixo Z), coloque a impressora em posição inicial, mova o extrusor para uma posição (Eixo Z) que esteja pelo menos 5 milímetros acima da base (se ainda não estiver), mova o extrusor para uma posição (XY) próxima ao centro da mesa, vá até o terminal OctoPrint e execute:

```
Z_ENDSTOP_CALIBRATE
```

Em seguida, siga as etapas em ["the paper test"](Bed_Level.md#the-paper-test) para determinar a distância real entre o bico e a mesa no local determinado. Depois que essas etapas forem concluídas, é permitido executar `ACCEPT` para aceitar a posição e salvar os resultados no arquivo de configuração com:

```
SAVE_CONFIG
```

É preferível usar uma chave de fim de curso (Eixo Z) na extremidade oposta do Eixo Z da mesa. No entanto, se for necessário se aproximar da mesa, é recomendado ajustar o fim de curso para que ele acione a uma pequena distância (por exemplo, 0,5 mm) acima da mesa. Quase todos os sensores de fim de curso podem ser ativados com segurança a uma pequena distância além do ponto de detecção. Depois, tenha em mente que o comando `Z_ENDSTOP_CALIBRATE` reporta um pequeno valor positivo (por exemplo, 0,5 mm) para a position_endstop (Eixo Z). Acionar o fim de curso enquanto ele ainda está a alguma distância da mesa reduz o risco de quedas da mesa.

Algumas impressoras têm a capacidade de ajustar manualmente o local do sensor físico do fim de curso. No entanto, é recomendado realizar o posicionamento do fim de curso (Eixo Z) no software com o Klipper - uma vez que o local físico do fim de curso esteja em um local conveniente, pode-se fazer quaisquer ajustes adicionais executando Z_ENDSTOP_CALIBRATE ou atualizando manualmente o position_endstop no arquivo de configuração.

## Ajustando os parafusos de nivelamento da mesa

O segredo para obter um bom nivelamento da mesa é utilizar o sistema de movimento de alta precisão da impressora durante o processo de nivelamento da base. Isso é feito comandando o extrusor para uma posição próxima a cada parafuso da base e, em seguida, ajustando esse parafuso até que a base esteja a uma distância da ponta do extrusor. O Klipper tem uma ferramenta para ajudar nisso. Para utilizá-la é necessário especificar o local (Eixo X e Y) de cada parafuso.

Isso é feito criando uma aba de configuração chamada de `[bed_screws]`. Pode parecer algo similar a:

```
[bed_screws]
screw1: 100, 50
screw2: 100, 150
screw3: 150, 100
```

Se um parafuso de mesa estiver sob ela, especifique a posição (Eixo X e Y) diretamente acima do parafuso. Se o parafuso estiver fora da mesa, especifique uma posição (Eixo X e Y) mais próxima do parafuso que ainda esteja dentro do alcance da mesa.

Quando o arquivo de configuração estiver pronto, execute `RESTART`, e então você poderá iniciar executando:

```
BED_SCREWS_ADJUST
```

Esta ferramenta moverá o extrusor para cada local (Eixos X e Y) do parafuso e, em seguida, moverá o extrusor para uma altura Z=0. Neste ponto, pode-se usar o "teste do papel" para ajustar o parafuso da mesa diretamente sob o extrusor. Veja as informações descritas em ["the paper test"](Bed_Level.md#the-paper-test), mas ajuste o parafuso da mesa em vez de mover o extrusor para alturas diferentes. Ajuste os parafusos da mesa até que haja um pequeno atrito ao esfregar o papel para frente e para trás.

Depois que o parafuso for ajustado de modo que um pequeno atrito ocorra, execute o comando `ACCEPT` ou `ADJUSTED`. Use o comando `ADJUSTED` se o parafuso da mesa precisar de um ajuste (normalmente qualquer movimento mais do que cerca de 1/8 do parafuso). Use o comando `ACCEPT` se nenhum ajuste significativo for necessário ou feito. Ambos os comandos farão com que o extrusor prossiga para o próximo parafuso. (Quando um comando `ADJUSTED` é usado, o extrusor agendará um ciclo adicional de ajustes do parafuso da mesa; o procedimento é concluído com sucesso quando todos os parafusos da mesa são verificados para não exigirem nenhum ajuste significativo.) Pode-se usar o comando `ABORT` para sair da ferramenta a qualquer momento.

Este sistema funciona melhor quando a impressora tem uma superfície de impressão plana (como vidro) e guias retas. Após a conclusão bem-sucedida do nivelamento da mesa, a mesma deve estar pronta para impressão.

### Ajustes de parafusos de mesa de precisão fina

Se a impressora usar três parafusos de mesa e todos os três parafusos estiverem sob a mesa, então pode ser possível executar uma segunda etapa de nivelamento de "alta precisão". Isso é feito movendo o extrusor para locais onde a mesa se move uma distância maior com cada ajuste de parafuso de mesa.

Por exemplo, considere uma mesa com parafusos nos locais A, B e C:

![bed_screws](img/bed_screws.svg.png)

Para cada ajuste feito no parafuso da mesa no local C, a mesa irá balançar ao longo de um pêndulo definido pelos dois parafusos da cama restantes (mostrado aqui como uma linha verde). Nessa situação, cada ajuste no parafuso da mesa em C irá mover a mesa na posição D uma quantidade maior do que diretamente em C. Assim, é possível fazer um ajuste melhorado do parafuso C quando o extrusor está na posição D.

Para usar esse recurso, é necessário determinar as coordenadas adicionais do extrusor e adicioná-las ao arquivo de configuração. Por exemplo:

```
[bed_screws]
screw1: 100, 50
screw1_fine_adjust: 0, 0
screw2: 100, 150
screw2_fine_adjust: 300, 300
screw3: 150, 100
screw3_fine_adjust: 0, 100
```

Quando esse recurso é habilitado, o `BED_SCREWS_ADJUST` solicitará ajustes bruscos diretamente acima de cada posição dos parafusos, e uma vez que eles forem aceitos, solicitará ajustes finos nos locais adicionais. Continue usando `ACCEPT` e `ADJUSTED` em cada posição.

## Ajustando parafusos de nivelamento da mesa usando o probe de mesa

Esta é outra forma de calibrar o nivelamento da mesa usando o probe. Para usá-la, você deve ter um probe de eixo Z (BL Touch, sensor indutivo, etc).

Para habilitar essa função, é necessário determinar as coordenadas do extrusor de modo que o probe (Eixo Z) fique acima dos parafusos, e então, adicioná-los ao arquivo de configuração. Por exemplo:

```
[screws_tilt_adjust]
screw1: -5, 30
screw1_name: front left screw
screw2: 155, 30
screw2_name: front right screw
screw3: 155, 190
screw3_name: rear right screw
screw4: -5, 190
screw4_name: rear left screw
horizontal_move_z: 10.
speed: 50.
screw_thread: CW-M3
```

O parafuso 1 (screw1) é sempre o ponto de referência para os outros, então o sistema assume que o parafuso 1 está na altura correta. Execute `G28` primeiro, e após execute `SCREWS_TILT_CALCULATE` - ele deve produzir uma saída similar a:

```
Send: G28
Recv: ok
Send: SCREWS_TILT_CALCULATE
Recv: // 01:20 significa 1 volta completa por 20 minutos, CW = sentido horário, CCW = sentido anti-horário
Recv: // parafuso frontal esquerdo (base): x=-5,0, y=30,0, z=2,48750
Recv: // parafuso frontal direito: x=155,0, y=30,0, z=2,36000: ajuste CW 01:15
Recv: // parafuso traseiro direito: y=155,0, y=190,0, z=2,71500: ajuste CCW 00:50
Recv: // veja o parafuso esquerdo: x=-5,0, y=190,0, z=2,47250: ajuste CW 00:02
Recv: ok
```

Isso significa que:

- O parafuso dianteiro esquerdo é o ponto de referência, e isso não deve ser alterado.
- O parafuso frontal direito deve ser girado no sentido horário uma (1) volta completa e um quarto (1/4) de volta
- O parafuso traseiro direito deve ser girado no sentido anti-horário por 50 minutos
- O parafuso traseiro esquerdo deve ser girado no sentido horário por 2 minutos (não obrigatório)

Note que "minutos" se refere a "minutos de um relógio". Então, por exemplo, 15 minutos é um quarto (1/4) de uma volta completa.

Repita o processo várias vezes até obter um bom nivelamento da mesa - normalmente quando todos os ajustes duram menos que 6 minutos.

Se estiver usando um probe montado na lateral do hotend (ou seja, que tenha um deslocamento de Eixo X e Y), observe que ajustar a inclinação da mesa invalidará qualquer calibração de probe anterior que tenha sido realizada com a mesa inclinada. Certifique-se de executar [probe calibration](Probe_Calibrate.md) após os parafusos da mesa terem sido ajustados.

O parâmetro `MAX_DEVIATION` é útil quando uma malha da cama salva é usada, para garantir que o nível da mesa não tenha se desviado muito de onde estava quando a malha foi criada. Por exemplo, `SCREWS_TILT_CALCULATE MAX_DEVIATION=0.01` pode ser adicionado ao Gcode inicial personalizado do fatiador antes que a malha seja carregada. Ele irá cancelar a impressão se o limite configurado for excedido (0,01mm, neste exemplo), dando ao usuário a chance de ajustar os parafusos e reiniciar a impressão.

O parâmetro `DIRECTION` é útil se você puder girar os parafusos de ajuste da mesa em apenas uma direção. Por exemplo, você pode ter parafusos que começam apertados na posição mais baixa (ou mais alta) possível, que só podem ser girados em uma única direção, para levantar (ou abaixar) a mesa. Se você só puder girar os parafusos no sentido horário, execute `SCREWS_TILT_CALCULATE DIRECTION=CW`. Se você só puder girá-los no sentido anti-horário, execute `SCREWS_TILT_CALCULATE DIRECTION=CCW`. Um ponto de referência adequado será escolhido de forma que a mesa possa ser nivelada girando todos os parafusos na direção fornecida.
