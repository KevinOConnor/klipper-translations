# Fase de parada

Este documento descreve o sistema de fim de curso ajustado por fase de passo do Klipper. Esta funcionalidade pode melhorar a precisão dos interruptores de fim de curso tradicionais. É mais útil ao usar um driver de motor de passo Trinamic que possui configuração de tempo de execução.

Um interruptor de fim de curso típico tem uma precisão de cerca de 100 mícrons. (Cada vez que um eixo é referenciado, a chave pode disparar um pouco mais cedo ou um pouco mais tarde.) Embora este seja um erro relativamente pequeno, ele pode resultar em artefatos indesejados. Em particular, este desvio de posição pode ser perceptível ao imprimir a primeira camada de um objeto. Em contraste, os motores de passo típicos podem obter uma precisão significativamente maior.

O mecanismo de fim de curso ajustado por fase de passo pode usar a precisão dos motores de passo para melhorar a precisão dos interruptores de fim de curso. Um motor de passo se move percorrendo uma série de fases até completar quatro "etapas completas". Assim, um motor de passo com 16 micropassos teria 64 fases e ao se mover no sentido positivo passaria pelas fases: 0, 1, 2, ... 61, 62, 63, 0, 1, 2, etc. Crucialmente, quando o motor de passo está em uma posição específica em um trilho linear, ele deve estar sempre na mesma fase do passo. Assim, quando um carro aciona a chave de fim de curso, o motor de passo que controla esse carro deve estar sempre na mesma fase do motor de passo. O sistema de fase de fim de curso do Klipper combina a fase de passo com o gatilho de fim de curso para melhorar a precisão do fim de curso.

Para utilizar esta funcionalidade é necessário ser capaz de identificar a fase do motor de passo. Se alguém estiver usando drivers Trinamic TMC2130, TMC2208, TMC2224 ou TMC2660 no modo de configuração de tempo de execução (ou seja, não no modo autônomo), o Klipper poderá consultar a fase de passo a partir do driver. (Também é possível usar este sistema em drivers de passo tradicionais se for possível redefinir os drivers de passo de forma confiável - veja detalhes abaixo.)

## Calibrando fases de fim de curso

Se estiver usando drivers de motor de passo Trinamic com configuração de tempo de execução, então pode-se calibrar as fases de fim de curso usando o comando ENDSTOP_PHASE_CALIBRATE. Comece adicionando o seguinte ao arquivo de configuração:

```
[endstop_phase]
```

Em seguida, REINICIE a impressora e execute um comando `G28` seguido por um comando `ENDSTOP_PHASE_CALIBRATE`. Em seguida, mova o cabeçote de ferramenta para um novo local e execute `G28` novamente. Tente mover o cabeçote da ferramenta para vários locais diferentes e execute novamente `G28` de cada posição. Execute pelo menos cinco comandos `G28`.

Depois de realizar o procedimento acima, o comando `ENDSTOP_PHASE_CALIBRATE` geralmente reportará a mesma (ou quase a mesma) fase para o stepper. Esta fase pode ser salva no arquivo de configuração para que todos os comandos futuros do G28 utilizem essa fase. (Portanto, em futuras operações de retorno à posição inicial, o Klipper obterá a mesma posição mesmo que o fim de curso seja acionado um pouco mais cedo ou um pouco mais tarde.)

Para salvar a fase de fim de curso para um motor de passo específico, execute algo como o seguinte:

```
ENDSTOP_PHASE_CALIBRATE STEPPER=stepper_z
```

Execute o procedimento acima para todos os steppers que deseja salvar. Normalmente, seria usado em stepper_z para impressoras cartesianas e corexy, e para stepper_a, stepper_b e stepper_c em impressoras delta. Por fim, execute o seguinte para atualizar o arquivo de configuração com os dados:

```
SAVE_CONFIG
```

### Notas Adicionais

* Esse recurso é mais útil em impressoras delta e no final Z de impressoras cartesianas/corexy. É possível usar esse recurso nos pontos finais XY de impressoras cartesianas, mas isso não é particularmente útil, pois é improvável que um pequeno erro na posição do ponto final X/Y afete a qualidade de impressão. Não é válido usar esse recurso nos fins de curso XY das impressoras Corexy (pois a posição XY não é determinada por um único passo na cinemática Corexy). Não é válido usar esse recurso em uma impressora que usa um fim de curso Z "probe:z_virtual_endstop" (já que a fase de passo só é estável se o fim de curso estiver em um local estático em um trilho).
* Depois de calibrar a fase de fim de curso, se o fim de curso for movido ou ajustado posteriormente, será necessário recalibrar o fim de curso. Remova os dados de calibração do arquivo de configuração e execute novamente as etapas acima.
* Para utilizar este sistema, o fim de curso deve ser suficientemente preciso para identificar a posição do passo dentro de dois "passos completos". Assim, por exemplo, se um stepper estiver usando 16 micropassos com uma distância de passo de 0,005 mm, o fim de curso deverá ter uma precisão de pelo menos 0,160 mm. Se alguém receber mensagens de erro do tipo "Endstop stepper_z fase incorreta", isso pode ser devido a um fim de curso que não é suficientemente preciso. Se a recalibração não ajudar, desative os ajustes de fase de fim de curso removendo-os do arquivo de configuração.
* Se alguém estiver usando um eixo Z tradicional controlado por passo (como em uma impressora cartesiana ou corexy) junto com parafusos de nivelamento de base tradicionais, então também é possível usar este sistema para organizar cada camada de impressão a ser executada em um limite de "etapa completa" . Para ativar esse recurso, certifique-se de que o fatiador G-Code esteja configurado com uma altura de camada que seja um múltiplo de uma "etapa completa", habilite manualmente a opção endstop_align_zero na seção de configuração endstop_phase (consulte [referência de configuração](Config_Reference.md#endstop_phase ) para obter mais detalhes) e, em seguida, nivelar novamente os parafusos da base.
* É possível usar este sistema com drivers de motor de passo tradicionais (não Trinamic). No entanto, fazer isso requer garantir que os drivers do motor de passo sejam reiniciados toda vez que o microcontrolador for reiniciado. (Se os dois são sempre redefinidos juntos, o Klipper pode determinar a fase do passo a passo rastreando o número total de passos que ele comandou para o passo a passo.) Atualmente, a única maneira de fazer isso de forma confiável é se tanto o microcontrolador quanto o motor de passo os drivers são alimentados exclusivamente por USB e a alimentação USB é fornecida por um host rodando em um Raspberry Pi. Nesta situação, pode-se especificar uma configuração mcu com "restart_method: rpi_usb" - essa opção fará com que o microcontrolador seja sempre redefinido por meio de uma redefinição de energia USB, o que faria com que tanto o microcontrolador quanto os drivers do motor de passo fossem redefinir juntos. Se usar esse mecanismo, será necessário configurar manualmente as seções de configuração "trigger_phase" (consulte [referência de configuração](Config_Reference.md#endstop_phase) para obter detalhes).
