# Import Sage
from sage.all import *

""" 
    Parameter file containing the schemes' parameters such as finite field 
    and elliptic curve parameters, strategies for isogeny tree traversal 
    and auxiliary parameters for public key compression. 
"""

# Turn off arithmetic proof
proof.arithmetic(False)

# Paramters defining the prime p = f*lA^eA*lB^eB - 1
f = 1
lA = 2
lB = 3
eA = 372
eB = 239

# Define the prime p
p = f*lA**eA*lB**eB-1
assert p.is_prime()
assert p == 10354717741769305252977768237866805321427389645549071170116189679054678940682478846502882896561066713624553211618840202385203911976522554393044160468771151816976706840078913334358399730952774926980235086850991501872665651576831

# Prime field of order p
Fp = GF(p)
R.<x> = PolynomialRing(Fp)
# The quadratic extension via x^2 + 1 since p = 3 mod 4
Fp2.<j> = Fp.extension(x^2 + 1)

# Bitlengths of group orders lA^eA and lB^eB, needed during the ladder functions
eAbits = eA
eBbits = 379

# E0 is the starting curve E0/Fp2: y^2=x^3+x (the A=0 Montgomery curve)
E0 = EllipticCurve(Fp2, [1,0])
assert E0.is_supersingular()

# The orders of the points on each side
oA = lA**eA
oB = lB**eB

# Identifyers for Alice and Bob
Alice = 0
Bob = 1

# Generator PA for the base field subgroup of order lA^eA
PA = 3**239*E0([11, sqrt(Fp(11^3+11))])
# Generator PB for the base field subgroup of order lB^eB
PB = 2**372*E0([6, sqrt(Fp(6^3+6))])

# Generator point coordinates specified explicitly by 4 Fp elements
XPA = Fp(5784307033157574162391672474522522983832304511218905707704962058799572462719474192769980361922537187309960524475241186527300549088533941865412874661143122262830946833377212881592965099601886901183961091839303261748866970694633)

YPA = Fp(5528941793184617364511452300962695084942165460078897881580666552736555418273496645894674314774001072353816966764689493098122556662755842001969781687909521301233517912821073526079191975713749455487083964491867894271185073160661)

assert XPA == PA[0] and YPA == PA[1]

XPB = Fp(4359917396849101231053336763700300892915096700013704210194781457801412731643988367389870886884336453245156775454336249199185654250159051929975600857047173121187832546031604804277991148436536445770452624367894371450077315674371)

YPB = Fp(106866937607440797536385002617766720826944674650271400721039514250889186719923133049487966730514682296643039694531052672873754128006844434636819566554364257913332237123293860767683395958817983684370065598726191088239028762772)

assert XPB == PB[0] and YPB == PB[1]

params_Alice = [XPB, XPA, YPA]
params_Bob = [XPA, XPB, YPB]

"""
   These are optimal strategies with respect to the cost ratios of 
   scalar multiplication by 4 and 4-isogeny evaluation of 
                     pA/qA = 2*12.1/21.6,
   and of point tripling and 3-isogeny evaluation of 
                     pB/qB = 24.3/16.0. 

   See the file optimalstrategies.txt for how they are computed.
"""
splits_Alice = [
0, 1, 1, 2, 2, 2, 3, 4, 4, 4, 4, 5, 5, 6, 7, 8, 8, 9, 9, 9, 9, 9, 9, 9, 12, 11,
12, 12, 13, 14, 15, 16, 16, 16, 16, 16, 16, 17, 17, 18, 18, 17, 21, 17, 18, 21,
20, 21, 21, 21, 21, 21, 22, 25, 25, 25, 26, 27, 28, 28, 29, 30, 31, 32, 32, 32,
32, 32, 32, 32, 33, 33, 33, 35, 36, 36, 33, 36, 35, 36, 36, 35, 36, 36, 37, 38,
38, 39, 40, 41, 42, 38, 39, 40, 41, 42, 40, 46, 42, 43, 46, 46, 46, 46, 48, 48,
48, 48, 49, 49, 48, 53, 54, 51, 52, 53, 54, 55, 56, 57, 58, 59, 59, 60, 62, 62,
63, 64, 64, 64, 64, 64, 64, 64, 64, 65, 65, 65, 65, 65, 66, 67, 65, 66, 67, 66,
69, 70, 66, 67, 66, 69, 70, 69, 70, 70, 71, 72, 71, 72, 72, 74, 74, 75, 72, 72,
74, 74, 75, 72, 72, 74, 75, 75, 72, 72, 74, 75, 75, 77, 77, 79, 80, 80, 82 ]

splits_Bob = [
0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 7, 8, 8, 8, 8, 9, 9, 9, 9, 9, 10,
12, 12, 12, 12, 12, 12, 13, 14, 14, 15, 16, 16, 16, 16, 16, 17, 16, 16, 17, 19,
19, 20, 21, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 24, 24, 25, 27, 27, 28, 28,
29, 28, 29, 28, 28, 28, 30, 28, 28, 28, 29, 30, 33, 33, 33, 33, 34, 35, 37, 37,
37, 37, 38, 38, 37, 38, 38, 38, 38, 38, 39, 43, 38, 38, 38, 38, 43, 40, 41, 42,
43, 48, 45, 46, 47, 47, 48, 49, 49, 49, 50, 51, 50, 49, 49, 49, 49, 51, 49, 53,
50, 51, 50, 51, 51, 51, 52, 55, 55, 55, 56, 56, 56, 56, 56, 58, 58, 61, 61, 61,
63, 63, 63, 64, 65, 65, 65, 65, 66, 66, 65, 65, 66, 66, 66, 66, 66, 66, 66, 71,
66, 73, 66, 66, 71, 66, 73, 66, 66, 71, 66, 73, 68, 68, 71, 71, 73, 73, 73, 75,
75, 78, 78, 78, 80, 80, 80, 81, 81, 82, 83, 84, 85, 86, 86, 86, 86, 86, 87, 86,
88, 86, 86, 86, 86, 88, 86, 88, 86, 86, 86, 88, 88, 86, 86, 86, 93, 90, 90, 92,
92, 92, 93, 93, 93, 93, 93, 97, 97, 97, 97, 97, 97 ]

MAX_Alice = 185
MAX_Bob = 239

# sqrt17 hardcoded
sqrt17 = Fp(1483538965666804829947069469909104059154140781635831028330640820709265337955392648044549164145551021689748496013107072560229759910814321769438913101160612783079068256317507381028230709001284064164607572283647211914550735845927)

"""
    This is a list of Fp2 values (coming in pairs of 2 Fp values) that are used
    in the elligator part of generating the 3-torsion basis. It is unclear how many
    of them actually need to be included. This list contains 10 pairs and was
    sufficient for all our experiments so far.
"""
list = [
8363425868352131165866658961353958144229814713712711329709230125390317605935848299098482339530092345619831440153678625003433928904114370855920283455545930313711955524679122308520245936538779748714805262456570059204845333965902,
9956459367085870435555546382564235885987874659181799202034797768321806673733152737022002785154871840023608857325807886908849915362040917685619385066126107516323756576998955129190768972069975891327149121972107213339101588054645
,
6144930856590964756685167380504563157961827953588137317347640432488186518896815315465645259926403525134570922304951070923678387107378958508658993589664191734009127665751748568914329020663777907486631313836162169963778632575103,
7536876520238641856265785405922723873301247545284897704150144618852913851906591160405377059136251837457871517965188606326279568717337728115592798767433428535635504650811536918778900787775462405867580948462033158740104179180513
,
3649145355892493092601130737620646564999583523362465770985774431722028233578445993491705627684624200456652890439467133392302895875864155375755562758304867985155239445020913595763546387942667577715103537504039074108229067555697,
3406345077809626624600272723767218026428182662708211688376153432351090934279684420539224235627330222344077159960128811405339493801931902376194527271450923735653716663943201145164797704596188717358325611329602031995352769518723
,
998267811748346322090246792849466614339797439606605388415575528085610645475302580158278377887610091561215574072604098957912985934804227515687363830062293591817437481569759107440934765403168660668480597527254704041283544182368,
6299254756541648319486140641915847200671962547147236779677914096206885693439062114609876986392650716657114941948886050368682406616380380110564244909143084100218367071201766960379602246502402243014532659396519266704951253335961
,
9039574854744291884896812083509992341844657264001872494805847834541453045297442044919522100073770691895959024848481318376368203592288440935586584203801603161116465577829836497600335844932077945214317550880170024404079352766731,
5313177263581054007047062863601524437514238821450682648253781051833432617355548678396777617808675927783520514552249891395696261872305818368128608110476976569675374699486270420502578099523615806334306845322118768973088647192804
,
2859481213219210500396709977967429237098625947545561341006056770829848169453286125614612704377152243303693651557660096209954612849929887786332341970767679754484316157978872890685237038734505830827748267342391094374943375131920,
1138411242251775238152745990579505410097343944723687139978725391891052467202849473111333480944440558901243384315784859847376479547976629563215374301794919876298590501570433821178061598483854203252967918244358816611958313201449
,
5367316808588549611959672587456268587017968216903026189392184608936835643094356482410776062932320943211212840412279678795203609893969868585047714432744978742112094996625228530338019331542883407309507442131133935246348240313824,
8851386602506850670872308704570103155979681025085103860948386649455451954463035242071270463410742468353606794120283518792127595418513953496815497229638470396909450421146806115735096998841868535615936457279783490329250009902864
,
7188443013090000550274508548166825175454104585924265018176320088548672687938897853151391910056849450233961696385929752588921372836392363086801317815771330941328643756283167206927316748142794608941899319827441473735709267505672,
903722033147219142615010295134657953920856503101452900469759971703938191957489992134730188791030728074838046354416419117573859136364260859565419493760310662535197081402282520962892909728318313535861418514530899913956220955925
,
5579969524527689275567102658266073446837331226905933874007222354369088971520147421829210289266033980819107236272056980685624788284996978462833907271313354456842447471315232788660234394084377803028810298750081928633804592071001,
2027913496375781342709202092544270940376528068585729437528950167030737801559327747994534434959292574519503847293579752256122111048046788748770552918005553068750068867624960377134298401661200309492117956725466050020896876890116
,
4624494142656684527622186866310605773524761035076660546060228364634691625190720012705349560205003073647077848112696936658132795530946054014061987955095884870409424853882937383611296712998217950743726984385808530127744032926811,
197817600549137552124791176633388479949283507786410028208787576903855465620499461221766306353468426335659142098186050318106570598412146855021358748541286458386045716472254226907403693901668635351880299813202412577271257317552
,
2376687573372173187082388104863803606689914688520586156889427110064854329629004523727865483902066455992739113122842261239999958200657732612662289575390386558617143244720633294000738727837611339026692156860041836920186210943397,
571596863167553918317507613300316352758870696217405884151555650801634422565829007267152248774410256621643050466484687438463486660418686787090913150831887879949892011899211783999445332654429272361339208027245506732927558500153
]