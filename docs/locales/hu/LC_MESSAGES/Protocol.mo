��    Q      �  m   ,      �     �  	   �               '     >     @     B     D     F  J   H  &   �  X   �  �       �  U   �	    6
  ;   E  P   �  &   �  !   �  U        q     �     �     �     �  ,  �        �     -  �  �   �    �  �   �  �  �  �  b     U     ]     ^     y     �  �  �     I     V     q     �  �   �  �  �  �  8  �  �   �  Y"  G  5$  �   }%  j  ?&  b  �(    *  �   ,  �   �,  �  �-  �  �/  '  &2  _  N4  V  �5  �   7  p   �7  �   
8  �  �8  H  g:  �   �;  �   t<  �   =  I   �=     >     !>  2   9>  @   l>  L   �>  �   �>  W   �?  �   %@  �  �@     _B  	   yB     �B     �B     �B     �B     �B     �B     �B     �B  J   �B  &   C  X   8C  �   �C  �   xD  N   qE  :  �E  >   �F  P   :G  &   �G  !   �G  U   �G     *H     7H     OH     hH     �H  t  �H     J  �    J  ;  K  �   JL  J  7M  
  �O  �  �P  5  vS     �V  #  �V  !   �W     �W     X  �  X     �Y     �Y     Z  	   Z    Z    2[  �  E]  �  �^  �  �`  X  �b  �   d  �  �d  w  �g  .  Ei  �   tk  G  dl  �  �m  �  vo  �  jr  �  �t  �  �v  �   )x  u   �x  �   By    �y  ;  �{  �   }  �   �}  �   �~  Y   k  $   �  '   �  4   �  @   G�  L   ��  �   Հ  W   ��  �    �     :   1          /       <   ,                         2   4           .   3   E      @                           C                     O                             A   0            	   
      )   F   6   &   (           5       N          $   %   >   J      -       8            G   I   #   ;      !   Q           B   K   +       D   M           =   ?   '              7   *   H      P   9   L   "        -2147483648 .. 4294967295 -32 .. 95 -4096 .. 12287 -524288 .. 1572863 -67108864 .. 201326591 1 2 3 4 5 <1 byte length><1 byte sequence><n-byte content><2 byte crc><1 byte sync>
 <VLQ encoded length><n-byte contents>
 <id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
 All data sent from host to micro-controller and vice-versa are contained in "message blocks". A message block has a two byte header and a three byte trailer. The format of a message block is: An "ack" is a message block with empty content (ie, a 5 byte message block) and a sequence number greater than the last received host sequence number. A "nak" is a message block with empty content and a sequence number less than the last received host sequence number. As an example, the following four commands might be placed in a single message block: As an exception to the above encoding rules, if a parameter to a command or response is a dynamic string then the parameter is not encoded as a simple VLQ integer. Instead it is encoded by transmitting the length as a VLQ encoded integer followed by the contents itself: Constants can also be exported. For example, the following: DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c value=%c");
 DECL_CONSTANT("SERIAL_BAUD", 250000);
 DECL_CONSTANT_STR("MCU", "pru");
 DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
 Data Dictionary Declaring commands Declaring constants Declaring enumerations Declaring responses Each message block sent from host to micro-controller contains a series of zero or more message commands in its contents. Each command starts with a [Variable Length Quantity](#variable-length-quantities) (VLQ) encoded integer command-id followed by zero or more VLQ parameters for the given command. Encoded size Enumerations allow the host code to use string identifiers for parameters that the micro-controller handles as integers. They are declared in the micro-controller code - for example: If the first example, the DECL_ENUMERATION() macro defines an enumeration for any command/response message with a parameter name of "spi_bus" or parameter name with a suffix of "_spi_bus". For those parameters the string "spi" is a valid value and it will be transmitted with an integer value of zero. In addition to information on the communication protocol, the data dictionary also contains the software version, enumerations (as defined by DECL_ENUMERATION), and constants (as defined by DECL_CONSTANT). In general, the parameters are described with printf() style syntax (eg, "%u"). The formatting directly corresponds to the human-readable view of commands (eg, "update_digital_out oid=7 value=1"). In the above example, "value=" is a parameter name and "%c" indicates the parameter is an integer. Internally, the parameter name is only used as documentation. In this example, the "%c" is also used as documentation to indicate the expected integer is 1 byte in size (the declared integer size does not impact the parsing or encoding). In order for meaningful communications to be established between micro-controller and host, both sides must agree on a "data dictionary". This data dictionary contains the integer identifiers for commands and responses along with their descriptions. In order to encode and parse the message contents, both the host and micro-controller must agree on the command ids and the number of parameters each command has. So, in the above example, both the host and micro-controller would know that "id_update_digital_out" is always followed by two parameters, and "id_get_config" and "id_get_clock" have zero parameters. The host and micro-controller share a "data dictionary" that maps the command descriptions (eg, "update_digital_out oid=%c value=%c") to their integer command-ids. When processing the data, the parser will know to expect a specific number of VLQ encoded parameters following a given command id. In the other direction, message blocks sent from micro-controller to host are designed to be error-free, but they do not have assured transmission. (Responses should not be corrupt, but they may go missing.) This is done to keep the implementation in the micro-controller simple. There is no automatic retransmission system for responses - the high-level code is expected to be capable of handling an occasional missing response (usually by re-requesting the content or setting up a recurring schedule of response transmission). The sequence number field in message blocks sent to the host is always one greater than the last received sequence number of message blocks received from the host. It is not used to track sequences of response message blocks. Integer It's also possible to declare an enumeration range. In the second example, a "pin" parameter (or any parameter with a suffix of "_pin") would accept PC0, PC1, PC2, ..., PC7 as valid values. The strings will be transmitted with integers 16, 17, 18, ..., 23. Low-level message encoding Message Block Contents Message Blocks Message commands sent from host to micro-controller are intended to be error-free. The micro-controller will check the CRC and sequence numbers in each message block to ensure the commands are accurate and in-order. The micro-controller always processes message blocks in-order - should it receive a block out-of-order it will discard it and any other out-of-order blocks until it receives blocks with the correct sequencing. Message flow Micro-controller Interface Output responses Protocol See the [mcu commands](MCU_Commands.md) document for information on available commands. See the [debugging](Debugging.md) document for information on how to translate a G-Code file into its corresponding human-readable micro-controller commands. See the [wikipedia article](https://en.wikipedia.org/wiki/Variable-length_quantity) for more information on the general format of VLQ encoded integers. Klipper uses an encoding scheme that supports both positive and negative integers. Integers close to zero use less bytes to encode and positive integers typically encode using less bytes than negative integers. The following table shows the number of bytes each integer takes to encode: The Klipper messaging protocol is used for low-level communication between the Klipper host software and the Klipper micro-controller software. At a high level the protocol can be thought of as a series of command and response strings that are compressed, transmitted, and then processed at the receiving side. An example series of commands in uncompressed human-readable format might look like: The Klipper transmission protocol can be thought of as a [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call) mechanism between micro-controller and host. The micro-controller software declares the commands that the host may invoke along with the response messages that it can generate. The host uses that information to command the micro-controller to perform actions and to interpret the results. The above declares a command named "update_digital_out". This allows the host to "invoke" this command which would cause the command_update_digital_out() C function to be executed in the micro-controller. The above also indicates that the command takes two integer parameters. When the command_update_digital_out() C code is executed, it will be passed an array containing these two integers - the first corresponding to the 'oid' and the second corresponding to the 'value'. The above transmits a "status" response message that contains two integer parameters ("clock" and "status"). The micro-controller build automatically finds all sendf() calls and generates encoders for them. The first parameter of the sendf() function describes the response and it is in the same format as command declarations. The command descriptions found in the data dictionary allow both the host and micro-controller to know which command parameters use simple VLQ encoding and which parameters use string encoding. The data dictionary is queried by sending "identify" commands to the micro-controller. The micro-controller will respond to each identify command with an "identify_response" message. Since these two commands are needed prior to obtaining the data dictionary, their integer ids and parameter types are hard-coded in both the micro-controller and the host. The "identify_response" response id is 0, the "identify" command id is 1. Other than having hard-coded ids the identify command and its response are declared and transmitted the same way as other commands and responses. No other command or response is hard-coded. The format of the message block is inspired by [HDLC](https://en.wikipedia.org/wiki/High-Level_Data_Link_Control) message frames. Like in HDLC, the message block may optionally contain an additional sync character at the start of the block. Unlike in HDLC, a sync character is not exclusive to the framing and may be present in the message block content. The format of the transmitted data dictionary itself is a zlib compressed JSON string. The micro-controller build process generates the string, compresses it, and stores it in the text section of the micro-controller flash. The data dictionary can be much larger than the maximum message block size - the host downloads it by sending multiple identify commands requesting progressive chunks of the data dictionary. Once all chunks are obtained the host will assemble the chunks, uncompress the data, and parse the contents. The goal of the protocol is to enable an error-free communication channel between the host and micro-controller that is low-latency, low-bandwidth, and low-complexity for the micro-controller. The host can arrange to register a callback function for each response. So, in effect, commands allow the host to invoke C functions in the micro-controller and responses allow the micro-controller software to invoke code in the host. The host queries the data dictionary when it first connects to the micro-controller. Once the host downloads the data dictionary from the micro-controller, it uses that data dictionary to encode all commands and to parse all responses from the micro-controller. The host must therefore handle a dynamic data dictionary. However, to keep the micro-controller software simple, the micro-controller always uses its static (compiled in) data dictionary. The length byte contains the number of bytes in the message block including the header and trailer bytes (thus the minimum message length is 5 bytes). The maximum message block length is currently 64 bytes. The sequence byte contains a 4 bit sequence number in the low-order bits and the high-order bits always contain 0x10 (the high-order bits are reserved for future use). The content bytes contain arbitrary data and its format is described in the following section. The crc bytes contain a 16bit CCITT [CRC](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) of the message block including the header bytes but excluding the trailer bytes. The sync byte is 0x7e. The low-level host code implements an automatic retransmission system for lost and corrupt message blocks sent to the micro-controller. To facilitate this, the micro-controller transmits an "ack message block" after each successfully received message block. The host schedules a timeout after sending each block and it will retransmit should the timeout expire without receiving a corresponding "ack". In addition, if the micro-controller detects a corrupt or out-of-order block it may transmit a "nak message block" to facilitate fast retransmission. The message contents for blocks sent from micro-controller to host follow the same format. The identifiers in these messages are "response ids", but they serve the same purpose and follow the same encoding rules. In practice, message blocks sent from the micro-controller to the host never contain more than one response in the message block contents. The micro-controller build uses the contents of DECL_COMMAND() and sendf() macros to generate the data dictionary. The build automatically assigns unique identifiers to each command and response. This system allows both the host and micro-controller code to seamlessly use descriptive human-readable names while still using minimal bandwidth. The micro-controller build will collect all commands declared with DECL_COMMAND(), determine their parameters, and arrange for them to be callable. The micro-controller software declares a "command" by using the DECL_COMMAND() macro in the C code. For example: The output() function is similar in usage to printf() - it is intended to generate and format arbitrary messages for human consumption. The protocol facilitates a "window" transmission system so that the host can have many outstanding message blocks in-flight at a time. (This is in addition to the many commands that may be present in a given message block.) This allows maximum bandwidth utilization even in the event of transmission latency. The timeout, retransmit, windowing, and ack mechanism are inspired by similar mechanisms in [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol). The sendf() macro should only be invoked from command or task handlers, and it should not be invoked from interrupts or timers. The code does not need to issue a sendf() in response to a received command, it is not limited in the number of times sendf() may be invoked, and it may invoke sendf() at any time from a task handler. This page provides a high-level description of the Klipper messaging protocol itself. It describes how messages are declared, encoded in binary format (the "compression" scheme), and transmitted. To accomplish the above RPC mechanism, each command and response is encoded into a binary format for transmission. This section describes the transmission system. To send information from the micro-controller to the host a "response" is generated. These are both declared and transmitted using the sendf() C macro. For example: To simplify debugging, there is also an output() C function. For example: Variable Length Quantities Variable length strings and encoded into the following eight VLQ integers: output("The value of %u is %s with size %u.", x, buf, buf_len);
 sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
 set_digital_out pin=PA3 value=1
set_digital_out pin=PA7 value=1
schedule_digital_out oid=8 clock=4000000 value=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
 update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
 would export a constant named "SERIAL_BAUD" with a value of 250000 from the micro-controller to the host. It is also possible to declare a constant that is a string - for example: Project-Id-Version: 
Report-Msgid-Bugs-To: yifeiding@protonmail.com
PO-Revision-Date: 2022-04-19 14:55+0200
Last-Translator: AntoszHUN
Language-Team: Hungarian <https://hosted.weblate.org/projects/klipper/protocol/hu/>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Generator: Poedit 3.0.1
 -2147483648 .. 4294967295 -32 .. 95 -4096 .. 12287 -524288 .. 1572863 -67108864 .. 201326591 1 2 3 4 5 <1 byte length><1 byte sequence><n-byte content><2 byte crc><1 byte sync>
 <VLQ encoded length><n-byte contents>
 <id_update_digital_out><6><1><id_update_digital_out><5><0><id_get_config><id_get_clock>
 A gazdagéptől a mikrovezérlőnek és fordítva küldött összes adat "üzenetblokkban" található. Az üzenetblokk két bájtos fejléccel és három bájtos üzenettel rendelkezik. Az üzenetblokkok formátuma a következő: Az "ack" egy üres tartalmú (azaz 5 bájtos) üzenetblokk, amelynek sorszáma nagyobb, mint az utolsó fogadott gazdagép sorszáma. A "nak" egy üres tartalmú üzenetblokk, amelynek sorszáma kisebb, mint az utolsó fogadott gazdagép sorszáma. A következő négy parancsot például egyetlen üzenetblokkba helyezhetjük: A fenti kódolási szabályok alóli kivételként, ha egy parancs vagy válasz paramétere dinamikus karakterlánc, akkor a paraméter nem egyszerű VLQ egész számként kódolódik. Ehelyett a kódolás úgy történik, hogy a hosszt VLQ kódolt egész számként továbbítják, amelyet maga a tartalom követ: A konstansok is exportálhatók. Például a következőképp: DECL_COMMAND(command_update_digital_out, "update_digital_out oid=%c value=%c");
 DECL_CONSTANT("SERIAL_BAUD", 250000);
 DECL_CONSTANT_STR("MCU", "pru");
 DECL_ENUMERATION("spi_bus", "spi", 0);

DECL_ENUMERATION_RANGE("pin", "PC0", 16, 8);
 Adatszótár Parancsok deklarálása Állandók deklarálása Felsorolások deklarálása Válaszok deklarálása Minden egyes, a gazdagépről a mikrokontrollernek küldött üzenetblokk tartalma nulla vagy több üzenetparancsból álló sorozatot tartalmaz. Minden parancs egy [Változó hosszúságú mennyiség](#variable-length-quantities) (VLQ) kódolt egész számú parancs azonosítóval kezdődik, amelyet az adott parancsra vonatkozó nulla vagy több VLQ paraméter követ. Kódolt méret A felsorolások lehetővé teszik a gazdakód számára, hogy a mikrokontroller által egész számokként kezelt paraméterekhez karakterlánc-azonosítókat használjon. Ezeket a mikrokontroller kódjában kell deklarálni - például: Ha az első példában a DECL_ENUMERATION() makró felsorolást definiál minden olyan parancs/válasz üzenethez, amelynek paraméterneve "spi_bus" vagy "_spi_bus" utótaggal rendelkezik. E paraméterek esetében az "SPI" karakterlánc érvényes érték, és nullás egész számértékkel kerül továbbításra. A kommunikációs protokollra vonatkozó információkon kívül az adatszótár tartalmazza a szoftver verzióját, a (DECL_ENUMERATION által meghatározott) felsorolásokat és a (DECL_CONSTANT által meghatározott) konstansokat is. Általában a paraméterek leírása printf() stílusú szintaxissal történik (pl. "%u"). A formázás közvetlenül megfelel a parancsok ember által olvasható nézetének (pl. "update_digital_out oid=7 value=1"). A fenti példában a "value=" a paraméter neve, a "%c" pedig azt jelzi, hogy a paraméter egész szám. Belsőleg a paraméternév csak dokumentációként használatos. Ebben a példában a "%c" is használható dokumentációként, amely jelzi, hogy a várt egész szám 1 bájt méretű (a deklarált egész szám nem befolyásolja az elemzést vagy a kódolást). Ahhoz, hogy a mikrokontroller és a gazdagép között értelmes kommunikáció jöjjön létre, mindkét félnek meg kell állapodnia egy "adatszótárban". Ez az adatszótár tartalmazza a parancsok és válaszok egészértékű azonosítóit és azok leírását. Az üzenet tartalmának kódolásához és elemzéséhez a gazdagépnek és a mikrokontrollernek meg kell egyeznie a parancs azonosítóiban és az egyes parancsok paramétereinek számában. Így a fenti példában mind a gazdagép, mind a mikrokontroller tudja, hogy az "id_update_digital_out" parancsot mindig két paraméter követi, és az "id_get_config" és a "id_get_clock" parancsnak nulla paramétere van. A gazdagép és a mikrokontroller megosztja az "adatszótárat", amely a parancsleírásokat (pl. "update_digital_out oid=%c value=%c") egész számú parancs-azonosítókra képezi le. Az adatok feldolgozása során az elemző tudni fogja, hogy egy adott parancs-id után meghatározott számú VLQ-kódolt paramétert várjon. A másik irányban a mikrokontrollerről a gazdagéphez küldött üzenetblokkokat úgy tervezték, hogy hibamentesek legyenek, de nincs biztosított átvitelük. (A válaszok nem lehetnek hibásak, de előfordulhat, hogy eltűnnek.) Ez azért történik, hogy a mikrokontrollerben egyszerű legyen a megvalósítás. Nincs automatikus újraküldési rendszer a válaszok számára. A magas szintű kódtól elvárható, hogy képes legyen kezelni az esetenként hiányzó válaszokat (általában a tartalom újrakérdezésével vagy a válaszküldés ismétlődő ütemezésének beállításával). Az állomásnak küldött üzenetblokkok sorszámmezője mindig eggyel nagyobb, mint az utolsó, az állomásról kapott üzenetblokkok sorszáma. Nem a válaszüzenetblokkok sorrendjének nyomon követésére szolgál. Egész Lehetőség van felsorolási tartomány kijelölésére is. A második példában egy "pin" paraméter (vagy bármely paraméter, amelynek utótagja "_pin") elfogadná a PC0, PC1, PC2, ..., PC7 értékeket. A karakterláncokat a 16, 17, 18, ..., ..., 23 egész számokkal kell továbbítani. Alacsony szintű üzenetkódolás Üzenetblokk tartalma Üzenetblokkok A gazdagépről a mikrokontrollerhez küldött üzenetparancsok hibátlanok. A mikrokontroller ellenőrzi a CRC-t és a sorszámokat minden egyes üzenetblokkban, hogy biztosítsa a parancsok pontosságát és sorrendiségét. A mikrokontroller mindig sorrendben dolgozza fel az üzenetblokkokat. Ha a sorrendtől eltérő blokkot kap, akkor azt és a többi sorrendtől eltérő blokkot is elveti, míg helyes sorrendű blokkokat nem kap. Üzenetáramlás Mikrovezérlő interfész Kimeneti válaszok Protokoll Az elérhető parancsokról az [mcu parancsok](MCU_Commands.md) dokumentumban olvashat bővebben. Tekintse meg a [hibakeresés](Debugging.md) dokumentumot a G-Kód fájl megfelelő, ember által olvasható mikrovezérlő parancsaira történő lefordításával kapcsolatban. A VLQ kódolt egész számok általános formátumáról lásd a [wikipedia cikket](https://en.wikipedia.org/wiki/Variable-length_quantity). A Klipper olyan kódolási sémát használ, amely támogatja a pozitív és negatív egész számokat is. A nullához közeli egészek kevesebb bájtot használnak a kódoláshoz, és a pozitív egészek kódolása általában kevesebb bájtot használ, mint a negatív egészeké. A következő táblázat mutatja, hogy az egyes egész számok kódolásához hány bájtra van szükség: A Klipper üzenetküldő protokoll a Klipper gazdagép szoftver és a Klipper mikrovezérlő szoftver közötti alacsony szintű kommunikációra szolgál. Magas szinten a protokoll felfogható parancs és válaszkarakterláncok sorozatának, amelyeket tömörítenek, továbbítanak, majd feldolgoznak a fogadó oldalon. Egy példa parancssorozat tömörítetlen, ember által olvasható formátumban így nézhet ki: A Klipper átviteli protokoll egy [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call) mechanizmusnak tekinthető a mikrovezérlő és a gazdagép között. A mikrovezérlő szoftver deklarálja azokat a parancsokat, amelyeket a gazdagép meghívhat, az általa generált válaszüzenetekkel együtt. A gazdagép ezeket az információkat arra használja fel, hogy parancsot adjon a mikrokontrollernek a műveletek végrehajtására és az eredmények értelmezésére. A fenti egy "update_digital_out" nevű parancsot deklarál. Ez lehetővé teszi a gazdagép számára, hogy ezt a parancsot "invoke", ami a command_update_digital_out() C függvény végrehajtását eredményezi a mikrovezérlőben. A fentiek azt is jelzik, hogy a parancs két egész paramétert vesz fel. A command_update_digital_out() C kód végrehajtásakor egy tömb kerül átadásra, amely ezt a két egész számot tartalmazza. Az első az 'oid'-nak, a második a 'value'-nak felel meg. A fenti egy "állapot" válaszüzenetet küld, amely két egész paramétert ("óra" és "állapot") tartalmaz. A mikrovezérlő szerkesztő automatikusan megtalálja az összes sendf() hívást, és kódolókat generál hozzájuk. A sendf() függvény első paramétere írja le a választ, és formátuma megegyezik a parancsdeklarációkkal. Az adatszótárban található parancsleírások lehetővé teszik a gazdagép és a mikrokontroller számára, hogy tudja, mely parancsparaméterek használnak egyszerű VLQ kódolást, és mely paraméterek string kódolást. Az adatszótárat a mikrokontrollerhez küldött "azonosító" parancsok segítségével lehet lekérdezni. A mikrokontroller minden egyes azonosító parancsra egy "identify_response" üzenettel válaszol. Mivel erre a két parancsra az adatszótár lekérdezése előtt van szükség, az egész számok azonosítói és a paramétertípusok mind a mikrokontrollerben, mind a gazdagépben szorosan kódolva vannak. Az "identify_response" válasz azonosítója 0, az "azonosító" parancs azonosítója 1. A keményen kódolt azonosítókon kívül az azonosító parancs és válasz ugyanúgy kerül deklarálásra és továbbításra, mint a többi parancs és válasz. Egyetlen más parancs vagy válasz sincs szorosan kódolva. Az üzenetblokk formátumát a [HDLC](https://en.wikipedia.org/wiki/High-Level_Data_Link_Control) üzenetkeretek ihlették. A HDLC-hez hasonlóan az üzenetblokk opcionálisan tartalmazhat egy további szinkronizálási karaktert a blokk elején. A HDLC-vel ellentétben a szinkronizálási karakter nem kizárólagos a keretben, és jelen lehet az üzenetblokk tartalmában. A továbbított adatszótár formátuma egy zlib tömörített JSON karakterlánc. A mikrokontroller építési folyamata létrehozza a karakterláncot, tömöríti, és a mikrokontroller flash-jének szöveges részében tárolja. Az adatszótár jóval nagyobb lehet, mint a maximális üzenetblokk mérete. A gazdagép úgy tölti le, hogy több azonosító parancsot küld, amelyek az adatszótár progresszív darabjait kérik. Ha az összes darabot megkapta, a gazdagép összeállítja a darabokat, kitömöríti az adatokat, és elemzi a tartalmukat. A protokoll célja, hogy hibamentes kommunikációs csatornát tegyen lehetővé a gazdagép és a mikrovezérlő között, amely alacsony késleltetésű, alacsony sávszélességű és alacsony bonyolultságú a mikrovezérlő számára. A gazdagép gondoskodhat arról, hogy minden válaszhoz visszahívási funkciót regisztráljon. Tehát valójában a parancsok lehetővé teszik a gazdagép számára, hogy meghívja a C függvényeket a mikrovezérlőben, a válaszok pedig lehetővé teszik, hogy a mikrovezérlő szoftvere kódot hívjon meg a gazdagépben. A gazdagép lekérdezi az adatszótárat, amikor először csatlakozik a mikrokontrollerhez. Amint ez megtörtént az adatszótárat használja az összes parancs kódolására és a mikrokontroller összes válaszának elemzésére. A gazdagépnek tehát dinamikus adatszótárat kell kezelnie. A mikrokontroller szoftverének egyszerűségének megőrzése érdekében azonban a mikrokontroller mindig a statikus (befordított) adatszótárát használja. A hosszbájt tartalmazza az üzenetblokkban lévő bájtok számát, beleértve a fejlécet és a követőbájtokat (így az üzenet minimális hossza 5 bájt). Az üzenetblokk maximális hossza jelenleg 64 bájt. A szekvencia bájt egy 4 bites szekvencia számot tartalmaz az alacsony rendű bitekben, a magas rendű bitek pedig mindig 0x10-et tartalmaznak (a magas rendű bitek későbbi használatra vannak fenntartva). A tartalmi bájtok tetszőleges adatokat tartalmaznak, és formátumukat a következő szakasz ismerteti. A crc bájtok tartalmazzák az üzenetblokk 16 bites CCITT [CRC](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) értékét, beleértve a fejlécbájtokat, de kivéve az üzenetbájtokat. A szinkronizálási bájt 0x7e. Az alacsony szintű gazdagép kód egy automatikus újraküldési rendszert valósít meg a mikrokontrollerhez küldött elveszett és hibás üzenetblokkok esetében. Ennek megkönnyítése érdekében a mikrokontroller minden egyes sikeresen fogadott üzenetblokk után egy "ack üzenetblokkot" küld. Az állomás minden egyes blokk elküldése után időkorlátot állít be, és ha az időkorlát lejár anélkül, hogy a megfelelő "ack" üzenetet megkapta volna, akkor újraküldi. Ezen túlmenően, ha a mikrokontroller hibás vagy rendellenes blokkot észlel, a gyors újraküldés megkönnyítése érdekében egy "nak üzenetblokkot" küldhet. A mikrokontrollerről a gazdagépnek küldött blokkok üzenettartalma ugyanezt a formátumot követi. Ezekben az üzenetekben szereplő azonosítók "válasz azonosítók", de ugyanazt a célt szolgálják és ugyanazokat a kódolási szabályokat követik. A gyakorlatban a mikrokontrollerről a gazdagépnek küldött üzenetblokkok soha nem tartalmaznak egynél több választ az üzenetblokk tartalmában. A mikrokontroller buildje a DECL_COMMAND() és sendf() makrók tartalmát használja az adatszótár létrehozásához. A build automatikusan egyedi azonosítókat rendel minden parancshoz és válaszhoz. Ez a rendszer lehetővé teszi, hogy a gazdagép, és a mikrokontroller kódja zökkenőmentesen használjon leíró, ember által olvasható neveket, miközben minimális sávszélességet használ. A mikrovezérlő szerkesztő összegyűjti a DECL_COMMAND()-al deklarált összes parancsot, meghatározza azok paramétereit, és gondoskodik a meghívásukról. A mikrokontroller szoftvere deklarál egy "parancsot" a DECL_COMMAND() makró használatával a C kódban. Például: Az output() függvény a printf() függvényhez hasonlóan használható. Célja tetszőleges üzenetek generálása és formázása emberi feldolgozásra. A protokoll megkönnyíti az "ablakos" átviteli rendszert, így a fogadó egyszerre több függőben lévő üzenetblokkal rendelkezhet. (Ez azon a sok parancson kívül, amelyek egy adott üzenetblokkban jelen lehetnek.) Ez lehetővé teszi a sávszélesség maximális kihasználását még átviteli késedelem esetén is. Az időkorlátozás, az újraküldés, az ablakozás és az ack mechanizmus a [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) hasonló mechanizmusai alapján készült. A sendf() makró csak parancs vagy feladatkezelőkből hívható meg, és nem hívható meg megszakításokból vagy időzítőkből. A kódnak nem kell sendf()-t kiadnia a kapott parancsra válaszul, nincs korlátozva a sendf() meghívásának száma, és a sendf()-t bármikor meghívhatja egy feladatkezelőből. Ez az oldal magának a Klipper üzenetküldő protokollnak a magas szintű leírását tartalmazza. Leírja az üzenetek deklarálását, bináris formátumú kódolását (a séma "tömörítését") és továbbítását. A fenti RPC-mechanizmus megvalósításához minden egyes parancs és válasz bináris formátumba van kódolva az átvitelhez. Ez a szakasz az átviteli rendszert írja le. A mikrovezérlőtől a gazdagépnek történő információ küldéséhez "válasz" jön létre. Ezek deklarálása és továbbítása a sendf() C makró használatával történik. Például: A hibakeresés egyszerűsítése érdekében van egy output() C függvény is. Például: Változó hosszúságú mennyiségek Változó hosszúságú karakterláncok és a következő nyolc VLQ egész számba kódolva: output("The value of %u is %s with size %u.", x, buf, buf_len);
 sendf("status clock=%u status=%c", sched_read_time(), sched_is_shutdown());
 set_digital_out pin=PA3 value=1
set_digital_out pin=PA7 value=1
schedule_digital_out oid=8 clock=4000000 value=0
queue_step oid=7 interval=7458 count=10 add=331
queue_step oid=7 interval=11717 count=4 add=1281
 update_digital_out oid=6 value=1
update_digital_out oid=5 value=0
get_config
get_clock
 egy "SERIAL_BAUD" nevű, 250000 értékű konstanst exportálna a mikrokontrollerből a gazdagépre. Lehetőség van olyan konstans deklarálására is, amely egy karakterlánc - például: 