
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    1000:	00007797          	auipc	a5,0x7
    1004:	aa078793          	addi	a5,a5,-1376 # 7aa0 <uninit>
    1008:	00009697          	auipc	a3,0x9
    100c:	1a868693          	addi	a3,a3,424 # a1b0 <buf>
    if(uninit[i] != '\0'){
    1010:	0007c703          	lbu	a4,0(a5)
    1014:	e709                	bnez	a4,101e <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
    1016:	0785                	addi	a5,a5,1
    1018:	fed79ce3          	bne	a5,a3,1010 <bsstest+0x10>
    101c:	8082                	ret
{
    101e:	1141                	addi	sp,sp,-16
    1020:	e406                	sd	ra,8(sp)
    1022:	e022                	sd	s0,0(sp)
    1024:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
    1026:	85aa                	mv	a1,a0
    1028:	00005517          	auipc	a0,0x5
    102c:	b3850513          	addi	a0,a0,-1224 # 5b60 <malloc+0x372>
    1030:	00004097          	auipc	ra,0x4
    1034:	700080e7          	jalr	1792(ra) # 5730 <printf>
      exit(1);
    1038:	4505                	li	a0,1
    103a:	00004097          	auipc	ra,0x4
    103e:	36e080e7          	jalr	878(ra) # 53a8 <exit>

0000000000001042 <iputtest>:
{
    1042:	1101                	addi	sp,sp,-32
    1044:	ec06                	sd	ra,24(sp)
    1046:	e822                	sd	s0,16(sp)
    1048:	e426                	sd	s1,8(sp)
    104a:	1000                	addi	s0,sp,32
    104c:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    104e:	00005517          	auipc	a0,0x5
    1052:	b2a50513          	addi	a0,a0,-1238 # 5b78 <malloc+0x38a>
    1056:	00004097          	auipc	ra,0x4
    105a:	3ba080e7          	jalr	954(ra) # 5410 <mkdir>
    105e:	04054563          	bltz	a0,10a8 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    1062:	00005517          	auipc	a0,0x5
    1066:	b1650513          	addi	a0,a0,-1258 # 5b78 <malloc+0x38a>
    106a:	00004097          	auipc	ra,0x4
    106e:	3ae080e7          	jalr	942(ra) # 5418 <chdir>
    1072:	04054963          	bltz	a0,10c4 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    1076:	00005517          	auipc	a0,0x5
    107a:	b4250513          	addi	a0,a0,-1214 # 5bb8 <malloc+0x3ca>
    107e:	00004097          	auipc	ra,0x4
    1082:	37a080e7          	jalr	890(ra) # 53f8 <unlink>
    1086:	04054d63          	bltz	a0,10e0 <iputtest+0x9e>
  if(chdir("/") < 0){
    108a:	00005517          	auipc	a0,0x5
    108e:	b5e50513          	addi	a0,a0,-1186 # 5be8 <malloc+0x3fa>
    1092:	00004097          	auipc	ra,0x4
    1096:	386080e7          	jalr	902(ra) # 5418 <chdir>
    109a:	06054163          	bltz	a0,10fc <iputtest+0xba>
}
    109e:	60e2                	ld	ra,24(sp)
    10a0:	6442                	ld	s0,16(sp)
    10a2:	64a2                	ld	s1,8(sp)
    10a4:	6105                	addi	sp,sp,32
    10a6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    10a8:	85a6                	mv	a1,s1
    10aa:	00005517          	auipc	a0,0x5
    10ae:	ad650513          	addi	a0,a0,-1322 # 5b80 <malloc+0x392>
    10b2:	00004097          	auipc	ra,0x4
    10b6:	67e080e7          	jalr	1662(ra) # 5730 <printf>
    exit(1);
    10ba:	4505                	li	a0,1
    10bc:	00004097          	auipc	ra,0x4
    10c0:	2ec080e7          	jalr	748(ra) # 53a8 <exit>
    printf("%s: chdir iputdir failed\n", s);
    10c4:	85a6                	mv	a1,s1
    10c6:	00005517          	auipc	a0,0x5
    10ca:	ad250513          	addi	a0,a0,-1326 # 5b98 <malloc+0x3aa>
    10ce:	00004097          	auipc	ra,0x4
    10d2:	662080e7          	jalr	1634(ra) # 5730 <printf>
    exit(1);
    10d6:	4505                	li	a0,1
    10d8:	00004097          	auipc	ra,0x4
    10dc:	2d0080e7          	jalr	720(ra) # 53a8 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    10e0:	85a6                	mv	a1,s1
    10e2:	00005517          	auipc	a0,0x5
    10e6:	ae650513          	addi	a0,a0,-1306 # 5bc8 <malloc+0x3da>
    10ea:	00004097          	auipc	ra,0x4
    10ee:	646080e7          	jalr	1606(ra) # 5730 <printf>
    exit(1);
    10f2:	4505                	li	a0,1
    10f4:	00004097          	auipc	ra,0x4
    10f8:	2b4080e7          	jalr	692(ra) # 53a8 <exit>
    printf("%s: chdir / failed\n", s);
    10fc:	85a6                	mv	a1,s1
    10fe:	00005517          	auipc	a0,0x5
    1102:	af250513          	addi	a0,a0,-1294 # 5bf0 <malloc+0x402>
    1106:	00004097          	auipc	ra,0x4
    110a:	62a080e7          	jalr	1578(ra) # 5730 <printf>
    exit(1);
    110e:	4505                	li	a0,1
    1110:	00004097          	auipc	ra,0x4
    1114:	298080e7          	jalr	664(ra) # 53a8 <exit>

0000000000001118 <rmdot>:
{
    1118:	1101                	addi	sp,sp,-32
    111a:	ec06                	sd	ra,24(sp)
    111c:	e822                	sd	s0,16(sp)
    111e:	e426                	sd	s1,8(sp)
    1120:	1000                	addi	s0,sp,32
    1122:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    1124:	00005517          	auipc	a0,0x5
    1128:	ae450513          	addi	a0,a0,-1308 # 5c08 <malloc+0x41a>
    112c:	00004097          	auipc	ra,0x4
    1130:	2e4080e7          	jalr	740(ra) # 5410 <mkdir>
    1134:	e549                	bnez	a0,11be <rmdot+0xa6>
  if(chdir("dots") != 0){
    1136:	00005517          	auipc	a0,0x5
    113a:	ad250513          	addi	a0,a0,-1326 # 5c08 <malloc+0x41a>
    113e:	00004097          	auipc	ra,0x4
    1142:	2da080e7          	jalr	730(ra) # 5418 <chdir>
    1146:	e951                	bnez	a0,11da <rmdot+0xc2>
  if(unlink(".") == 0){
    1148:	00005517          	auipc	a0,0x5
    114c:	af850513          	addi	a0,a0,-1288 # 5c40 <malloc+0x452>
    1150:	00004097          	auipc	ra,0x4
    1154:	2a8080e7          	jalr	680(ra) # 53f8 <unlink>
    1158:	cd59                	beqz	a0,11f6 <rmdot+0xde>
  if(unlink("..") == 0){
    115a:	00005517          	auipc	a0,0x5
    115e:	b0650513          	addi	a0,a0,-1274 # 5c60 <malloc+0x472>
    1162:	00004097          	auipc	ra,0x4
    1166:	296080e7          	jalr	662(ra) # 53f8 <unlink>
    116a:	c545                	beqz	a0,1212 <rmdot+0xfa>
  if(chdir("/") != 0){
    116c:	00005517          	auipc	a0,0x5
    1170:	a7c50513          	addi	a0,a0,-1412 # 5be8 <malloc+0x3fa>
    1174:	00004097          	auipc	ra,0x4
    1178:	2a4080e7          	jalr	676(ra) # 5418 <chdir>
    117c:	e94d                	bnez	a0,122e <rmdot+0x116>
  if(unlink("dots/.") == 0){
    117e:	00005517          	auipc	a0,0x5
    1182:	b0250513          	addi	a0,a0,-1278 # 5c80 <malloc+0x492>
    1186:	00004097          	auipc	ra,0x4
    118a:	272080e7          	jalr	626(ra) # 53f8 <unlink>
    118e:	cd55                	beqz	a0,124a <rmdot+0x132>
  if(unlink("dots/..") == 0){
    1190:	00005517          	auipc	a0,0x5
    1194:	b1850513          	addi	a0,a0,-1256 # 5ca8 <malloc+0x4ba>
    1198:	00004097          	auipc	ra,0x4
    119c:	260080e7          	jalr	608(ra) # 53f8 <unlink>
    11a0:	c179                	beqz	a0,1266 <rmdot+0x14e>
  if(unlink("dots") != 0){
    11a2:	00005517          	auipc	a0,0x5
    11a6:	a6650513          	addi	a0,a0,-1434 # 5c08 <malloc+0x41a>
    11aa:	00004097          	auipc	ra,0x4
    11ae:	24e080e7          	jalr	590(ra) # 53f8 <unlink>
    11b2:	e961                	bnez	a0,1282 <rmdot+0x16a>
}
    11b4:	60e2                	ld	ra,24(sp)
    11b6:	6442                	ld	s0,16(sp)
    11b8:	64a2                	ld	s1,8(sp)
    11ba:	6105                	addi	sp,sp,32
    11bc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    11be:	85a6                	mv	a1,s1
    11c0:	00005517          	auipc	a0,0x5
    11c4:	a5050513          	addi	a0,a0,-1456 # 5c10 <malloc+0x422>
    11c8:	00004097          	auipc	ra,0x4
    11cc:	568080e7          	jalr	1384(ra) # 5730 <printf>
    exit(1);
    11d0:	4505                	li	a0,1
    11d2:	00004097          	auipc	ra,0x4
    11d6:	1d6080e7          	jalr	470(ra) # 53a8 <exit>
    printf("%s: chdir dots failed\n", s);
    11da:	85a6                	mv	a1,s1
    11dc:	00005517          	auipc	a0,0x5
    11e0:	a4c50513          	addi	a0,a0,-1460 # 5c28 <malloc+0x43a>
    11e4:	00004097          	auipc	ra,0x4
    11e8:	54c080e7          	jalr	1356(ra) # 5730 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	00004097          	auipc	ra,0x4
    11f2:	1ba080e7          	jalr	442(ra) # 53a8 <exit>
    printf("%s: rm . worked!\n", s);
    11f6:	85a6                	mv	a1,s1
    11f8:	00005517          	auipc	a0,0x5
    11fc:	a5050513          	addi	a0,a0,-1456 # 5c48 <malloc+0x45a>
    1200:	00004097          	auipc	ra,0x4
    1204:	530080e7          	jalr	1328(ra) # 5730 <printf>
    exit(1);
    1208:	4505                	li	a0,1
    120a:	00004097          	auipc	ra,0x4
    120e:	19e080e7          	jalr	414(ra) # 53a8 <exit>
    printf("%s: rm .. worked!\n", s);
    1212:	85a6                	mv	a1,s1
    1214:	00005517          	auipc	a0,0x5
    1218:	a5450513          	addi	a0,a0,-1452 # 5c68 <malloc+0x47a>
    121c:	00004097          	auipc	ra,0x4
    1220:	514080e7          	jalr	1300(ra) # 5730 <printf>
    exit(1);
    1224:	4505                	li	a0,1
    1226:	00004097          	auipc	ra,0x4
    122a:	182080e7          	jalr	386(ra) # 53a8 <exit>
    printf("%s: chdir / failed\n", s);
    122e:	85a6                	mv	a1,s1
    1230:	00005517          	auipc	a0,0x5
    1234:	9c050513          	addi	a0,a0,-1600 # 5bf0 <malloc+0x402>
    1238:	00004097          	auipc	ra,0x4
    123c:	4f8080e7          	jalr	1272(ra) # 5730 <printf>
    exit(1);
    1240:	4505                	li	a0,1
    1242:	00004097          	auipc	ra,0x4
    1246:	166080e7          	jalr	358(ra) # 53a8 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    124a:	85a6                	mv	a1,s1
    124c:	00005517          	auipc	a0,0x5
    1250:	a3c50513          	addi	a0,a0,-1476 # 5c88 <malloc+0x49a>
    1254:	00004097          	auipc	ra,0x4
    1258:	4dc080e7          	jalr	1244(ra) # 5730 <printf>
    exit(1);
    125c:	4505                	li	a0,1
    125e:	00004097          	auipc	ra,0x4
    1262:	14a080e7          	jalr	330(ra) # 53a8 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    1266:	85a6                	mv	a1,s1
    1268:	00005517          	auipc	a0,0x5
    126c:	a4850513          	addi	a0,a0,-1464 # 5cb0 <malloc+0x4c2>
    1270:	00004097          	auipc	ra,0x4
    1274:	4c0080e7          	jalr	1216(ra) # 5730 <printf>
    exit(1);
    1278:	4505                	li	a0,1
    127a:	00004097          	auipc	ra,0x4
    127e:	12e080e7          	jalr	302(ra) # 53a8 <exit>
    printf("%s: unlink dots failed!\n", s);
    1282:	85a6                	mv	a1,s1
    1284:	00005517          	auipc	a0,0x5
    1288:	a4c50513          	addi	a0,a0,-1460 # 5cd0 <malloc+0x4e2>
    128c:	00004097          	auipc	ra,0x4
    1290:	4a4080e7          	jalr	1188(ra) # 5730 <printf>
    exit(1);
    1294:	4505                	li	a0,1
    1296:	00004097          	auipc	ra,0x4
    129a:	112080e7          	jalr	274(ra) # 53a8 <exit>

000000000000129e <exitiputtest>:
{
    129e:	7179                	addi	sp,sp,-48
    12a0:	f406                	sd	ra,40(sp)
    12a2:	f022                	sd	s0,32(sp)
    12a4:	ec26                	sd	s1,24(sp)
    12a6:	1800                	addi	s0,sp,48
    12a8:	84aa                	mv	s1,a0
  pid = fork();
    12aa:	00004097          	auipc	ra,0x4
    12ae:	0f6080e7          	jalr	246(ra) # 53a0 <fork>
  if(pid < 0){
    12b2:	04054663          	bltz	a0,12fe <exitiputtest+0x60>
  if(pid == 0){
    12b6:	ed45                	bnez	a0,136e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    12b8:	00005517          	auipc	a0,0x5
    12bc:	8c050513          	addi	a0,a0,-1856 # 5b78 <malloc+0x38a>
    12c0:	00004097          	auipc	ra,0x4
    12c4:	150080e7          	jalr	336(ra) # 5410 <mkdir>
    12c8:	04054963          	bltz	a0,131a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    12cc:	00005517          	auipc	a0,0x5
    12d0:	8ac50513          	addi	a0,a0,-1876 # 5b78 <malloc+0x38a>
    12d4:	00004097          	auipc	ra,0x4
    12d8:	144080e7          	jalr	324(ra) # 5418 <chdir>
    12dc:	04054d63          	bltz	a0,1336 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    12e0:	00005517          	auipc	a0,0x5
    12e4:	8d850513          	addi	a0,a0,-1832 # 5bb8 <malloc+0x3ca>
    12e8:	00004097          	auipc	ra,0x4
    12ec:	110080e7          	jalr	272(ra) # 53f8 <unlink>
    12f0:	06054163          	bltz	a0,1352 <exitiputtest+0xb4>
    exit(0);
    12f4:	4501                	li	a0,0
    12f6:	00004097          	auipc	ra,0x4
    12fa:	0b2080e7          	jalr	178(ra) # 53a8 <exit>
    printf("%s: fork failed\n", s);
    12fe:	85a6                	mv	a1,s1
    1300:	00005517          	auipc	a0,0x5
    1304:	9f050513          	addi	a0,a0,-1552 # 5cf0 <malloc+0x502>
    1308:	00004097          	auipc	ra,0x4
    130c:	428080e7          	jalr	1064(ra) # 5730 <printf>
    exit(1);
    1310:	4505                	li	a0,1
    1312:	00004097          	auipc	ra,0x4
    1316:	096080e7          	jalr	150(ra) # 53a8 <exit>
      printf("%s: mkdir failed\n", s);
    131a:	85a6                	mv	a1,s1
    131c:	00005517          	auipc	a0,0x5
    1320:	86450513          	addi	a0,a0,-1948 # 5b80 <malloc+0x392>
    1324:	00004097          	auipc	ra,0x4
    1328:	40c080e7          	jalr	1036(ra) # 5730 <printf>
      exit(1);
    132c:	4505                	li	a0,1
    132e:	00004097          	auipc	ra,0x4
    1332:	07a080e7          	jalr	122(ra) # 53a8 <exit>
      printf("%s: child chdir failed\n", s);
    1336:	85a6                	mv	a1,s1
    1338:	00005517          	auipc	a0,0x5
    133c:	9d050513          	addi	a0,a0,-1584 # 5d08 <malloc+0x51a>
    1340:	00004097          	auipc	ra,0x4
    1344:	3f0080e7          	jalr	1008(ra) # 5730 <printf>
      exit(1);
    1348:	4505                	li	a0,1
    134a:	00004097          	auipc	ra,0x4
    134e:	05e080e7          	jalr	94(ra) # 53a8 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    1352:	85a6                	mv	a1,s1
    1354:	00005517          	auipc	a0,0x5
    1358:	87450513          	addi	a0,a0,-1932 # 5bc8 <malloc+0x3da>
    135c:	00004097          	auipc	ra,0x4
    1360:	3d4080e7          	jalr	980(ra) # 5730 <printf>
      exit(1);
    1364:	4505                	li	a0,1
    1366:	00004097          	auipc	ra,0x4
    136a:	042080e7          	jalr	66(ra) # 53a8 <exit>
  wait(&xstatus);
    136e:	fdc40513          	addi	a0,s0,-36
    1372:	00004097          	auipc	ra,0x4
    1376:	03e080e7          	jalr	62(ra) # 53b0 <wait>
  exit(xstatus);
    137a:	fdc42503          	lw	a0,-36(s0)
    137e:	00004097          	auipc	ra,0x4
    1382:	02a080e7          	jalr	42(ra) # 53a8 <exit>

0000000000001386 <exitwait>:
{
    1386:	7139                	addi	sp,sp,-64
    1388:	fc06                	sd	ra,56(sp)
    138a:	f822                	sd	s0,48(sp)
    138c:	f426                	sd	s1,40(sp)
    138e:	f04a                	sd	s2,32(sp)
    1390:	ec4e                	sd	s3,24(sp)
    1392:	e852                	sd	s4,16(sp)
    1394:	0080                	addi	s0,sp,64
    1396:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1398:	4901                	li	s2,0
    139a:	06400993          	li	s3,100
    pid = fork();
    139e:	00004097          	auipc	ra,0x4
    13a2:	002080e7          	jalr	2(ra) # 53a0 <fork>
    13a6:	84aa                	mv	s1,a0
    if(pid < 0){
    13a8:	02054a63          	bltz	a0,13dc <exitwait+0x56>
    if(pid){
    13ac:	c151                	beqz	a0,1430 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    13ae:	fcc40513          	addi	a0,s0,-52
    13b2:	00004097          	auipc	ra,0x4
    13b6:	ffe080e7          	jalr	-2(ra) # 53b0 <wait>
    13ba:	02951f63          	bne	a0,s1,13f8 <exitwait+0x72>
      if(i != xstate) {
    13be:	fcc42783          	lw	a5,-52(s0)
    13c2:	05279963          	bne	a5,s2,1414 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    13c6:	2905                	addiw	s2,s2,1
    13c8:	fd391be3          	bne	s2,s3,139e <exitwait+0x18>
}
    13cc:	70e2                	ld	ra,56(sp)
    13ce:	7442                	ld	s0,48(sp)
    13d0:	74a2                	ld	s1,40(sp)
    13d2:	7902                	ld	s2,32(sp)
    13d4:	69e2                	ld	s3,24(sp)
    13d6:	6a42                	ld	s4,16(sp)
    13d8:	6121                	addi	sp,sp,64
    13da:	8082                	ret
      printf("%s: fork failed\n", s);
    13dc:	85d2                	mv	a1,s4
    13de:	00005517          	auipc	a0,0x5
    13e2:	91250513          	addi	a0,a0,-1774 # 5cf0 <malloc+0x502>
    13e6:	00004097          	auipc	ra,0x4
    13ea:	34a080e7          	jalr	842(ra) # 5730 <printf>
      exit(1);
    13ee:	4505                	li	a0,1
    13f0:	00004097          	auipc	ra,0x4
    13f4:	fb8080e7          	jalr	-72(ra) # 53a8 <exit>
        printf("%s: wait wrong pid\n", s);
    13f8:	85d2                	mv	a1,s4
    13fa:	00005517          	auipc	a0,0x5
    13fe:	92650513          	addi	a0,a0,-1754 # 5d20 <malloc+0x532>
    1402:	00004097          	auipc	ra,0x4
    1406:	32e080e7          	jalr	814(ra) # 5730 <printf>
        exit(1);
    140a:	4505                	li	a0,1
    140c:	00004097          	auipc	ra,0x4
    1410:	f9c080e7          	jalr	-100(ra) # 53a8 <exit>
        printf("%s: wait wrong exit status\n", s);
    1414:	85d2                	mv	a1,s4
    1416:	00005517          	auipc	a0,0x5
    141a:	92250513          	addi	a0,a0,-1758 # 5d38 <malloc+0x54a>
    141e:	00004097          	auipc	ra,0x4
    1422:	312080e7          	jalr	786(ra) # 5730 <printf>
        exit(1);
    1426:	4505                	li	a0,1
    1428:	00004097          	auipc	ra,0x4
    142c:	f80080e7          	jalr	-128(ra) # 53a8 <exit>
      exit(i);
    1430:	854a                	mv	a0,s2
    1432:	00004097          	auipc	ra,0x4
    1436:	f76080e7          	jalr	-138(ra) # 53a8 <exit>

000000000000143a <twochildren>:
{
    143a:	1101                	addi	sp,sp,-32
    143c:	ec06                	sd	ra,24(sp)
    143e:	e822                	sd	s0,16(sp)
    1440:	e426                	sd	s1,8(sp)
    1442:	e04a                	sd	s2,0(sp)
    1444:	1000                	addi	s0,sp,32
    1446:	892a                	mv	s2,a0
    1448:	3e800493          	li	s1,1000
    int pid1 = fork();
    144c:	00004097          	auipc	ra,0x4
    1450:	f54080e7          	jalr	-172(ra) # 53a0 <fork>
    if(pid1 < 0){
    1454:	02054c63          	bltz	a0,148c <twochildren+0x52>
    if(pid1 == 0){
    1458:	c921                	beqz	a0,14a8 <twochildren+0x6e>
      int pid2 = fork();
    145a:	00004097          	auipc	ra,0x4
    145e:	f46080e7          	jalr	-186(ra) # 53a0 <fork>
      if(pid2 < 0){
    1462:	04054763          	bltz	a0,14b0 <twochildren+0x76>
      if(pid2 == 0){
    1466:	c13d                	beqz	a0,14cc <twochildren+0x92>
        wait(0);
    1468:	4501                	li	a0,0
    146a:	00004097          	auipc	ra,0x4
    146e:	f46080e7          	jalr	-186(ra) # 53b0 <wait>
        wait(0);
    1472:	4501                	li	a0,0
    1474:	00004097          	auipc	ra,0x4
    1478:	f3c080e7          	jalr	-196(ra) # 53b0 <wait>
  for(int i = 0; i < 1000; i++){
    147c:	34fd                	addiw	s1,s1,-1
    147e:	f4f9                	bnez	s1,144c <twochildren+0x12>
}
    1480:	60e2                	ld	ra,24(sp)
    1482:	6442                	ld	s0,16(sp)
    1484:	64a2                	ld	s1,8(sp)
    1486:	6902                	ld	s2,0(sp)
    1488:	6105                	addi	sp,sp,32
    148a:	8082                	ret
      printf("%s: fork failed\n", s);
    148c:	85ca                	mv	a1,s2
    148e:	00005517          	auipc	a0,0x5
    1492:	86250513          	addi	a0,a0,-1950 # 5cf0 <malloc+0x502>
    1496:	00004097          	auipc	ra,0x4
    149a:	29a080e7          	jalr	666(ra) # 5730 <printf>
      exit(1);
    149e:	4505                	li	a0,1
    14a0:	00004097          	auipc	ra,0x4
    14a4:	f08080e7          	jalr	-248(ra) # 53a8 <exit>
      exit(0);
    14a8:	00004097          	auipc	ra,0x4
    14ac:	f00080e7          	jalr	-256(ra) # 53a8 <exit>
        printf("%s: fork failed\n", s);
    14b0:	85ca                	mv	a1,s2
    14b2:	00005517          	auipc	a0,0x5
    14b6:	83e50513          	addi	a0,a0,-1986 # 5cf0 <malloc+0x502>
    14ba:	00004097          	auipc	ra,0x4
    14be:	276080e7          	jalr	630(ra) # 5730 <printf>
        exit(1);
    14c2:	4505                	li	a0,1
    14c4:	00004097          	auipc	ra,0x4
    14c8:	ee4080e7          	jalr	-284(ra) # 53a8 <exit>
        exit(0);
    14cc:	00004097          	auipc	ra,0x4
    14d0:	edc080e7          	jalr	-292(ra) # 53a8 <exit>

00000000000014d4 <forkfork>:
{
    14d4:	7179                	addi	sp,sp,-48
    14d6:	f406                	sd	ra,40(sp)
    14d8:	f022                	sd	s0,32(sp)
    14da:	ec26                	sd	s1,24(sp)
    14dc:	1800                	addi	s0,sp,48
    14de:	84aa                	mv	s1,a0
    int pid = fork();
    14e0:	00004097          	auipc	ra,0x4
    14e4:	ec0080e7          	jalr	-320(ra) # 53a0 <fork>
    if(pid < 0){
    14e8:	04054163          	bltz	a0,152a <forkfork+0x56>
    if(pid == 0){
    14ec:	cd29                	beqz	a0,1546 <forkfork+0x72>
    int pid = fork();
    14ee:	00004097          	auipc	ra,0x4
    14f2:	eb2080e7          	jalr	-334(ra) # 53a0 <fork>
    if(pid < 0){
    14f6:	02054a63          	bltz	a0,152a <forkfork+0x56>
    if(pid == 0){
    14fa:	c531                	beqz	a0,1546 <forkfork+0x72>
    wait(&xstatus);
    14fc:	fdc40513          	addi	a0,s0,-36
    1500:	00004097          	auipc	ra,0x4
    1504:	eb0080e7          	jalr	-336(ra) # 53b0 <wait>
    if(xstatus != 0) {
    1508:	fdc42783          	lw	a5,-36(s0)
    150c:	ebbd                	bnez	a5,1582 <forkfork+0xae>
    wait(&xstatus);
    150e:	fdc40513          	addi	a0,s0,-36
    1512:	00004097          	auipc	ra,0x4
    1516:	e9e080e7          	jalr	-354(ra) # 53b0 <wait>
    if(xstatus != 0) {
    151a:	fdc42783          	lw	a5,-36(s0)
    151e:	e3b5                	bnez	a5,1582 <forkfork+0xae>
}
    1520:	70a2                	ld	ra,40(sp)
    1522:	7402                	ld	s0,32(sp)
    1524:	64e2                	ld	s1,24(sp)
    1526:	6145                	addi	sp,sp,48
    1528:	8082                	ret
      printf("%s: fork failed", s);
    152a:	85a6                	mv	a1,s1
    152c:	00005517          	auipc	a0,0x5
    1530:	82c50513          	addi	a0,a0,-2004 # 5d58 <malloc+0x56a>
    1534:	00004097          	auipc	ra,0x4
    1538:	1fc080e7          	jalr	508(ra) # 5730 <printf>
      exit(1);
    153c:	4505                	li	a0,1
    153e:	00004097          	auipc	ra,0x4
    1542:	e6a080e7          	jalr	-406(ra) # 53a8 <exit>
{
    1546:	0c800493          	li	s1,200
        int pid1 = fork();
    154a:	00004097          	auipc	ra,0x4
    154e:	e56080e7          	jalr	-426(ra) # 53a0 <fork>
        if(pid1 < 0){
    1552:	00054f63          	bltz	a0,1570 <forkfork+0x9c>
        if(pid1 == 0){
    1556:	c115                	beqz	a0,157a <forkfork+0xa6>
        wait(0);
    1558:	4501                	li	a0,0
    155a:	00004097          	auipc	ra,0x4
    155e:	e56080e7          	jalr	-426(ra) # 53b0 <wait>
      for(int j = 0; j < 200; j++){
    1562:	34fd                	addiw	s1,s1,-1
    1564:	f0fd                	bnez	s1,154a <forkfork+0x76>
      exit(0);
    1566:	4501                	li	a0,0
    1568:	00004097          	auipc	ra,0x4
    156c:	e40080e7          	jalr	-448(ra) # 53a8 <exit>
          exit(1);
    1570:	4505                	li	a0,1
    1572:	00004097          	auipc	ra,0x4
    1576:	e36080e7          	jalr	-458(ra) # 53a8 <exit>
          exit(0);
    157a:	00004097          	auipc	ra,0x4
    157e:	e2e080e7          	jalr	-466(ra) # 53a8 <exit>
      printf("%s: fork in child failed", s);
    1582:	85a6                	mv	a1,s1
    1584:	00004517          	auipc	a0,0x4
    1588:	7e450513          	addi	a0,a0,2020 # 5d68 <malloc+0x57a>
    158c:	00004097          	auipc	ra,0x4
    1590:	1a4080e7          	jalr	420(ra) # 5730 <printf>
      exit(1);
    1594:	4505                	li	a0,1
    1596:	00004097          	auipc	ra,0x4
    159a:	e12080e7          	jalr	-494(ra) # 53a8 <exit>

000000000000159e <reparent2>:
{
    159e:	1101                	addi	sp,sp,-32
    15a0:	ec06                	sd	ra,24(sp)
    15a2:	e822                	sd	s0,16(sp)
    15a4:	e426                	sd	s1,8(sp)
    15a6:	1000                	addi	s0,sp,32
    15a8:	32000493          	li	s1,800
    int pid1 = fork();
    15ac:	00004097          	auipc	ra,0x4
    15b0:	df4080e7          	jalr	-524(ra) # 53a0 <fork>
    if(pid1 < 0){
    15b4:	00054f63          	bltz	a0,15d2 <reparent2+0x34>
    if(pid1 == 0){
    15b8:	c915                	beqz	a0,15ec <reparent2+0x4e>
    wait(0);
    15ba:	4501                	li	a0,0
    15bc:	00004097          	auipc	ra,0x4
    15c0:	df4080e7          	jalr	-524(ra) # 53b0 <wait>
  for(int i = 0; i < 800; i++){
    15c4:	34fd                	addiw	s1,s1,-1
    15c6:	f0fd                	bnez	s1,15ac <reparent2+0xe>
  exit(0);
    15c8:	4501                	li	a0,0
    15ca:	00004097          	auipc	ra,0x4
    15ce:	dde080e7          	jalr	-546(ra) # 53a8 <exit>
      printf("fork failed\n");
    15d2:	00005517          	auipc	a0,0x5
    15d6:	01e50513          	addi	a0,a0,30 # 65f0 <malloc+0xe02>
    15da:	00004097          	auipc	ra,0x4
    15de:	156080e7          	jalr	342(ra) # 5730 <printf>
      exit(1);
    15e2:	4505                	li	a0,1
    15e4:	00004097          	auipc	ra,0x4
    15e8:	dc4080e7          	jalr	-572(ra) # 53a8 <exit>
      fork();
    15ec:	00004097          	auipc	ra,0x4
    15f0:	db4080e7          	jalr	-588(ra) # 53a0 <fork>
      fork();
    15f4:	00004097          	auipc	ra,0x4
    15f8:	dac080e7          	jalr	-596(ra) # 53a0 <fork>
      exit(0);
    15fc:	4501                	li	a0,0
    15fe:	00004097          	auipc	ra,0x4
    1602:	daa080e7          	jalr	-598(ra) # 53a8 <exit>

0000000000001606 <forktest>:
{
    1606:	7179                	addi	sp,sp,-48
    1608:	f406                	sd	ra,40(sp)
    160a:	f022                	sd	s0,32(sp)
    160c:	ec26                	sd	s1,24(sp)
    160e:	e84a                	sd	s2,16(sp)
    1610:	e44e                	sd	s3,8(sp)
    1612:	1800                	addi	s0,sp,48
    1614:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1616:	4481                	li	s1,0
    1618:	3e800913          	li	s2,1000
    pid = fork();
    161c:	00004097          	auipc	ra,0x4
    1620:	d84080e7          	jalr	-636(ra) # 53a0 <fork>
    if(pid < 0)
    1624:	02054863          	bltz	a0,1654 <forktest+0x4e>
    if(pid == 0)
    1628:	c115                	beqz	a0,164c <forktest+0x46>
  for(n=0; n<N; n++){
    162a:	2485                	addiw	s1,s1,1
    162c:	ff2498e3          	bne	s1,s2,161c <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1630:	85ce                	mv	a1,s3
    1632:	00004517          	auipc	a0,0x4
    1636:	76e50513          	addi	a0,a0,1902 # 5da0 <malloc+0x5b2>
    163a:	00004097          	auipc	ra,0x4
    163e:	0f6080e7          	jalr	246(ra) # 5730 <printf>
    exit(1);
    1642:	4505                	li	a0,1
    1644:	00004097          	auipc	ra,0x4
    1648:	d64080e7          	jalr	-668(ra) # 53a8 <exit>
      exit(0);
    164c:	00004097          	auipc	ra,0x4
    1650:	d5c080e7          	jalr	-676(ra) # 53a8 <exit>
  if (n == 0) {
    1654:	cc9d                	beqz	s1,1692 <forktest+0x8c>
  if(n == N){
    1656:	3e800793          	li	a5,1000
    165a:	fcf48be3          	beq	s1,a5,1630 <forktest+0x2a>
  for(; n > 0; n--){
    165e:	00905b63          	blez	s1,1674 <forktest+0x6e>
    if(wait(0) < 0){
    1662:	4501                	li	a0,0
    1664:	00004097          	auipc	ra,0x4
    1668:	d4c080e7          	jalr	-692(ra) # 53b0 <wait>
    166c:	04054163          	bltz	a0,16ae <forktest+0xa8>
  for(; n > 0; n--){
    1670:	34fd                	addiw	s1,s1,-1
    1672:	f8e5                	bnez	s1,1662 <forktest+0x5c>
  if(wait(0) != -1){
    1674:	4501                	li	a0,0
    1676:	00004097          	auipc	ra,0x4
    167a:	d3a080e7          	jalr	-710(ra) # 53b0 <wait>
    167e:	57fd                	li	a5,-1
    1680:	04f51563          	bne	a0,a5,16ca <forktest+0xc4>
}
    1684:	70a2                	ld	ra,40(sp)
    1686:	7402                	ld	s0,32(sp)
    1688:	64e2                	ld	s1,24(sp)
    168a:	6942                	ld	s2,16(sp)
    168c:	69a2                	ld	s3,8(sp)
    168e:	6145                	addi	sp,sp,48
    1690:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1692:	85ce                	mv	a1,s3
    1694:	00004517          	auipc	a0,0x4
    1698:	6f450513          	addi	a0,a0,1780 # 5d88 <malloc+0x59a>
    169c:	00004097          	auipc	ra,0x4
    16a0:	094080e7          	jalr	148(ra) # 5730 <printf>
    exit(1);
    16a4:	4505                	li	a0,1
    16a6:	00004097          	auipc	ra,0x4
    16aa:	d02080e7          	jalr	-766(ra) # 53a8 <exit>
      printf("%s: wait stopped early\n", s);
    16ae:	85ce                	mv	a1,s3
    16b0:	00004517          	auipc	a0,0x4
    16b4:	71850513          	addi	a0,a0,1816 # 5dc8 <malloc+0x5da>
    16b8:	00004097          	auipc	ra,0x4
    16bc:	078080e7          	jalr	120(ra) # 5730 <printf>
      exit(1);
    16c0:	4505                	li	a0,1
    16c2:	00004097          	auipc	ra,0x4
    16c6:	ce6080e7          	jalr	-794(ra) # 53a8 <exit>
    printf("%s: wait got too many\n", s);
    16ca:	85ce                	mv	a1,s3
    16cc:	00004517          	auipc	a0,0x4
    16d0:	71450513          	addi	a0,a0,1812 # 5de0 <malloc+0x5f2>
    16d4:	00004097          	auipc	ra,0x4
    16d8:	05c080e7          	jalr	92(ra) # 5730 <printf>
    exit(1);
    16dc:	4505                	li	a0,1
    16de:	00004097          	auipc	ra,0x4
    16e2:	cca080e7          	jalr	-822(ra) # 53a8 <exit>

00000000000016e6 <kernmem>:
{
    16e6:	715d                	addi	sp,sp,-80
    16e8:	e486                	sd	ra,72(sp)
    16ea:	e0a2                	sd	s0,64(sp)
    16ec:	fc26                	sd	s1,56(sp)
    16ee:	f84a                	sd	s2,48(sp)
    16f0:	f44e                	sd	s3,40(sp)
    16f2:	f052                	sd	s4,32(sp)
    16f4:	ec56                	sd	s5,24(sp)
    16f6:	0880                	addi	s0,sp,80
    16f8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    16fa:	4485                	li	s1,1
    16fc:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    16fe:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1700:	69b1                	lui	s3,0xc
    1702:	35098993          	addi	s3,s3,848 # c350 <buf+0x21a0>
    1706:	1003d937          	lui	s2,0x1003d
    170a:	090e                	slli	s2,s2,0x3
    170c:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x100302c0>
    pid = fork();
    1710:	00004097          	auipc	ra,0x4
    1714:	c90080e7          	jalr	-880(ra) # 53a0 <fork>
    if(pid < 0){
    1718:	02054963          	bltz	a0,174a <kernmem+0x64>
    if(pid == 0){
    171c:	c529                	beqz	a0,1766 <kernmem+0x80>
    wait(&xstatus);
    171e:	fbc40513          	addi	a0,s0,-68
    1722:	00004097          	auipc	ra,0x4
    1726:	c8e080e7          	jalr	-882(ra) # 53b0 <wait>
    if(xstatus != -1)  // did kernel kill child?
    172a:	fbc42783          	lw	a5,-68(s0)
    172e:	05579c63          	bne	a5,s5,1786 <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1732:	94ce                	add	s1,s1,s3
    1734:	fd249ee3          	bne	s1,s2,1710 <kernmem+0x2a>
}
    1738:	60a6                	ld	ra,72(sp)
    173a:	6406                	ld	s0,64(sp)
    173c:	74e2                	ld	s1,56(sp)
    173e:	7942                	ld	s2,48(sp)
    1740:	79a2                	ld	s3,40(sp)
    1742:	7a02                	ld	s4,32(sp)
    1744:	6ae2                	ld	s5,24(sp)
    1746:	6161                	addi	sp,sp,80
    1748:	8082                	ret
      printf("%s: fork failed\n", s);
    174a:	85d2                	mv	a1,s4
    174c:	00004517          	auipc	a0,0x4
    1750:	5a450513          	addi	a0,a0,1444 # 5cf0 <malloc+0x502>
    1754:	00004097          	auipc	ra,0x4
    1758:	fdc080e7          	jalr	-36(ra) # 5730 <printf>
      exit(1);
    175c:	4505                	li	a0,1
    175e:	00004097          	auipc	ra,0x4
    1762:	c4a080e7          	jalr	-950(ra) # 53a8 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    1766:	0004c603          	lbu	a2,0(s1)
    176a:	85a6                	mv	a1,s1
    176c:	00004517          	auipc	a0,0x4
    1770:	68c50513          	addi	a0,a0,1676 # 5df8 <malloc+0x60a>
    1774:	00004097          	auipc	ra,0x4
    1778:	fbc080e7          	jalr	-68(ra) # 5730 <printf>
      exit(1);
    177c:	4505                	li	a0,1
    177e:	00004097          	auipc	ra,0x4
    1782:	c2a080e7          	jalr	-982(ra) # 53a8 <exit>
      exit(1);
    1786:	4505                	li	a0,1
    1788:	00004097          	auipc	ra,0x4
    178c:	c20080e7          	jalr	-992(ra) # 53a8 <exit>

0000000000001790 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
    1790:	7179                	addi	sp,sp,-48
    1792:	f406                	sd	ra,40(sp)
    1794:	f022                	sd	s0,32(sp)
    1796:	ec26                	sd	s1,24(sp)
    1798:	1800                	addi	s0,sp,48
    179a:	84aa                	mv	s1,a0
  int pid;
  int xstatus;
  
  pid = fork();
    179c:	00004097          	auipc	ra,0x4
    17a0:	c04080e7          	jalr	-1020(ra) # 53a0 <fork>
  if(pid == 0) {
    17a4:	c115                	beqz	a0,17c8 <stacktest+0x38>
    char *sp = (char *) r_sp();
    sp -= PGSIZE;
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", *sp);
    exit(1);
  } else if(pid < 0){
    17a6:	04054363          	bltz	a0,17ec <stacktest+0x5c>
    printf("%s: fork failed\n", s);
    exit(1);
  }
  wait(&xstatus);
    17aa:	fdc40513          	addi	a0,s0,-36
    17ae:	00004097          	auipc	ra,0x4
    17b2:	c02080e7          	jalr	-1022(ra) # 53b0 <wait>
  if(xstatus == -1)  // kernel killed child?
    17b6:	fdc42503          	lw	a0,-36(s0)
    17ba:	57fd                	li	a5,-1
    17bc:	04f50663          	beq	a0,a5,1808 <stacktest+0x78>
    exit(0);
  else
    exit(xstatus);
    17c0:	00004097          	auipc	ra,0x4
    17c4:	be8080e7          	jalr	-1048(ra) # 53a8 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    17c8:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    17ca:	77fd                	lui	a5,0xfffff
    17cc:	97ba                	add	a5,a5,a4
    17ce:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff1e40>
    17d2:	00004517          	auipc	a0,0x4
    17d6:	64650513          	addi	a0,a0,1606 # 5e18 <malloc+0x62a>
    17da:	00004097          	auipc	ra,0x4
    17de:	f56080e7          	jalr	-170(ra) # 5730 <printf>
    exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	bc4080e7          	jalr	-1084(ra) # 53a8 <exit>
    printf("%s: fork failed\n", s);
    17ec:	85a6                	mv	a1,s1
    17ee:	00004517          	auipc	a0,0x4
    17f2:	50250513          	addi	a0,a0,1282 # 5cf0 <malloc+0x502>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	f3a080e7          	jalr	-198(ra) # 5730 <printf>
    exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	ba8080e7          	jalr	-1112(ra) # 53a8 <exit>
    exit(0);
    1808:	4501                	li	a0,0
    180a:	00004097          	auipc	ra,0x4
    180e:	b9e080e7          	jalr	-1122(ra) # 53a8 <exit>

0000000000001812 <openiputtest>:
{
    1812:	7179                	addi	sp,sp,-48
    1814:	f406                	sd	ra,40(sp)
    1816:	f022                	sd	s0,32(sp)
    1818:	ec26                	sd	s1,24(sp)
    181a:	1800                	addi	s0,sp,48
    181c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    181e:	00004517          	auipc	a0,0x4
    1822:	62250513          	addi	a0,a0,1570 # 5e40 <malloc+0x652>
    1826:	00004097          	auipc	ra,0x4
    182a:	bea080e7          	jalr	-1046(ra) # 5410 <mkdir>
    182e:	04054263          	bltz	a0,1872 <openiputtest+0x60>
  pid = fork();
    1832:	00004097          	auipc	ra,0x4
    1836:	b6e080e7          	jalr	-1170(ra) # 53a0 <fork>
  if(pid < 0){
    183a:	04054a63          	bltz	a0,188e <openiputtest+0x7c>
  if(pid == 0){
    183e:	e93d                	bnez	a0,18b4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    1840:	4589                	li	a1,2
    1842:	00004517          	auipc	a0,0x4
    1846:	5fe50513          	addi	a0,a0,1534 # 5e40 <malloc+0x652>
    184a:	00004097          	auipc	ra,0x4
    184e:	b9e080e7          	jalr	-1122(ra) # 53e8 <open>
    if(fd >= 0){
    1852:	04054c63          	bltz	a0,18aa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    1856:	85a6                	mv	a1,s1
    1858:	00004517          	auipc	a0,0x4
    185c:	60850513          	addi	a0,a0,1544 # 5e60 <malloc+0x672>
    1860:	00004097          	auipc	ra,0x4
    1864:	ed0080e7          	jalr	-304(ra) # 5730 <printf>
      exit(1);
    1868:	4505                	li	a0,1
    186a:	00004097          	auipc	ra,0x4
    186e:	b3e080e7          	jalr	-1218(ra) # 53a8 <exit>
    printf("%s: mkdir oidir failed\n", s);
    1872:	85a6                	mv	a1,s1
    1874:	00004517          	auipc	a0,0x4
    1878:	5d450513          	addi	a0,a0,1492 # 5e48 <malloc+0x65a>
    187c:	00004097          	auipc	ra,0x4
    1880:	eb4080e7          	jalr	-332(ra) # 5730 <printf>
    exit(1);
    1884:	4505                	li	a0,1
    1886:	00004097          	auipc	ra,0x4
    188a:	b22080e7          	jalr	-1246(ra) # 53a8 <exit>
    printf("%s: fork failed\n", s);
    188e:	85a6                	mv	a1,s1
    1890:	00004517          	auipc	a0,0x4
    1894:	46050513          	addi	a0,a0,1120 # 5cf0 <malloc+0x502>
    1898:	00004097          	auipc	ra,0x4
    189c:	e98080e7          	jalr	-360(ra) # 5730 <printf>
    exit(1);
    18a0:	4505                	li	a0,1
    18a2:	00004097          	auipc	ra,0x4
    18a6:	b06080e7          	jalr	-1274(ra) # 53a8 <exit>
    exit(0);
    18aa:	4501                	li	a0,0
    18ac:	00004097          	auipc	ra,0x4
    18b0:	afc080e7          	jalr	-1284(ra) # 53a8 <exit>
  sleep(1);
    18b4:	4505                	li	a0,1
    18b6:	00004097          	auipc	ra,0x4
    18ba:	b82080e7          	jalr	-1150(ra) # 5438 <sleep>
  if(unlink("oidir") != 0){
    18be:	00004517          	auipc	a0,0x4
    18c2:	58250513          	addi	a0,a0,1410 # 5e40 <malloc+0x652>
    18c6:	00004097          	auipc	ra,0x4
    18ca:	b32080e7          	jalr	-1230(ra) # 53f8 <unlink>
    18ce:	cd19                	beqz	a0,18ec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    18d0:	85a6                	mv	a1,s1
    18d2:	00004517          	auipc	a0,0x4
    18d6:	5b650513          	addi	a0,a0,1462 # 5e88 <malloc+0x69a>
    18da:	00004097          	auipc	ra,0x4
    18de:	e56080e7          	jalr	-426(ra) # 5730 <printf>
    exit(1);
    18e2:	4505                	li	a0,1
    18e4:	00004097          	auipc	ra,0x4
    18e8:	ac4080e7          	jalr	-1340(ra) # 53a8 <exit>
  wait(&xstatus);
    18ec:	fdc40513          	addi	a0,s0,-36
    18f0:	00004097          	auipc	ra,0x4
    18f4:	ac0080e7          	jalr	-1344(ra) # 53b0 <wait>
  exit(xstatus);
    18f8:	fdc42503          	lw	a0,-36(s0)
    18fc:	00004097          	auipc	ra,0x4
    1900:	aac080e7          	jalr	-1364(ra) # 53a8 <exit>

0000000000001904 <opentest>:
{
    1904:	1101                	addi	sp,sp,-32
    1906:	ec06                	sd	ra,24(sp)
    1908:	e822                	sd	s0,16(sp)
    190a:	e426                	sd	s1,8(sp)
    190c:	1000                	addi	s0,sp,32
    190e:	84aa                	mv	s1,a0
  fd = open("echo", 0);
    1910:	4581                	li	a1,0
    1912:	00004517          	auipc	a0,0x4
    1916:	58e50513          	addi	a0,a0,1422 # 5ea0 <malloc+0x6b2>
    191a:	00004097          	auipc	ra,0x4
    191e:	ace080e7          	jalr	-1330(ra) # 53e8 <open>
  if(fd < 0){
    1922:	02054663          	bltz	a0,194e <opentest+0x4a>
  close(fd);
    1926:	00004097          	auipc	ra,0x4
    192a:	aaa080e7          	jalr	-1366(ra) # 53d0 <close>
  fd = open("doesnotexist", 0);
    192e:	4581                	li	a1,0
    1930:	00004517          	auipc	a0,0x4
    1934:	59050513          	addi	a0,a0,1424 # 5ec0 <malloc+0x6d2>
    1938:	00004097          	auipc	ra,0x4
    193c:	ab0080e7          	jalr	-1360(ra) # 53e8 <open>
  if(fd >= 0){
    1940:	02055563          	bgez	a0,196a <opentest+0x66>
}
    1944:	60e2                	ld	ra,24(sp)
    1946:	6442                	ld	s0,16(sp)
    1948:	64a2                	ld	s1,8(sp)
    194a:	6105                	addi	sp,sp,32
    194c:	8082                	ret
    printf("%s: open echo failed!\n", s);
    194e:	85a6                	mv	a1,s1
    1950:	00004517          	auipc	a0,0x4
    1954:	55850513          	addi	a0,a0,1368 # 5ea8 <malloc+0x6ba>
    1958:	00004097          	auipc	ra,0x4
    195c:	dd8080e7          	jalr	-552(ra) # 5730 <printf>
    exit(1);
    1960:	4505                	li	a0,1
    1962:	00004097          	auipc	ra,0x4
    1966:	a46080e7          	jalr	-1466(ra) # 53a8 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
    196a:	85a6                	mv	a1,s1
    196c:	00004517          	auipc	a0,0x4
    1970:	56450513          	addi	a0,a0,1380 # 5ed0 <malloc+0x6e2>
    1974:	00004097          	auipc	ra,0x4
    1978:	dbc080e7          	jalr	-580(ra) # 5730 <printf>
    exit(1);
    197c:	4505                	li	a0,1
    197e:	00004097          	auipc	ra,0x4
    1982:	a2a080e7          	jalr	-1494(ra) # 53a8 <exit>

0000000000001986 <createtest>:
{
    1986:	7179                	addi	sp,sp,-48
    1988:	f406                	sd	ra,40(sp)
    198a:	f022                	sd	s0,32(sp)
    198c:	ec26                	sd	s1,24(sp)
    198e:	e84a                	sd	s2,16(sp)
    1990:	e44e                	sd	s3,8(sp)
    1992:	1800                	addi	s0,sp,48
  name[0] = 'a';
    1994:	00006797          	auipc	a5,0x6
    1998:	ffc78793          	addi	a5,a5,-4 # 7990 <name>
    199c:	06100713          	li	a4,97
    19a0:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
    19a4:	00078123          	sb	zero,2(a5)
    19a8:	03000493          	li	s1,48
    name[1] = '0' + i;
    19ac:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
    19ae:	06400993          	li	s3,100
    name[1] = '0' + i;
    19b2:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
    19b6:	20200593          	li	a1,514
    19ba:	854a                	mv	a0,s2
    19bc:	00004097          	auipc	ra,0x4
    19c0:	a2c080e7          	jalr	-1492(ra) # 53e8 <open>
    close(fd);
    19c4:	00004097          	auipc	ra,0x4
    19c8:	a0c080e7          	jalr	-1524(ra) # 53d0 <close>
  for(i = 0; i < N; i++){
    19cc:	2485                	addiw	s1,s1,1
    19ce:	0ff4f493          	andi	s1,s1,255
    19d2:	ff3490e3          	bne	s1,s3,19b2 <createtest+0x2c>
  name[0] = 'a';
    19d6:	00006797          	auipc	a5,0x6
    19da:	fba78793          	addi	a5,a5,-70 # 7990 <name>
    19de:	06100713          	li	a4,97
    19e2:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
    19e6:	00078123          	sb	zero,2(a5)
    19ea:	03000493          	li	s1,48
    name[1] = '0' + i;
    19ee:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
    19f0:	06400993          	li	s3,100
    name[1] = '0' + i;
    19f4:	009900a3          	sb	s1,1(s2)
    unlink(name);
    19f8:	854a                	mv	a0,s2
    19fa:	00004097          	auipc	ra,0x4
    19fe:	9fe080e7          	jalr	-1538(ra) # 53f8 <unlink>
  for(i = 0; i < N; i++){
    1a02:	2485                	addiw	s1,s1,1
    1a04:	0ff4f493          	andi	s1,s1,255
    1a08:	ff3496e3          	bne	s1,s3,19f4 <createtest+0x6e>
}
    1a0c:	70a2                	ld	ra,40(sp)
    1a0e:	7402                	ld	s0,32(sp)
    1a10:	64e2                	ld	s1,24(sp)
    1a12:	6942                	ld	s2,16(sp)
    1a14:	69a2                	ld	s3,8(sp)
    1a16:	6145                	addi	sp,sp,48
    1a18:	8082                	ret

0000000000001a1a <forkforkfork>:
{
    1a1a:	1101                	addi	sp,sp,-32
    1a1c:	ec06                	sd	ra,24(sp)
    1a1e:	e822                	sd	s0,16(sp)
    1a20:	e426                	sd	s1,8(sp)
    1a22:	1000                	addi	s0,sp,32
    1a24:	84aa                	mv	s1,a0
  unlink("stopforking");
    1a26:	00004517          	auipc	a0,0x4
    1a2a:	4d250513          	addi	a0,a0,1234 # 5ef8 <malloc+0x70a>
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	9ca080e7          	jalr	-1590(ra) # 53f8 <unlink>
  int pid = fork();
    1a36:	00004097          	auipc	ra,0x4
    1a3a:	96a080e7          	jalr	-1686(ra) # 53a0 <fork>
  if(pid < 0){
    1a3e:	04054563          	bltz	a0,1a88 <forkforkfork+0x6e>
  if(pid == 0){
    1a42:	c12d                	beqz	a0,1aa4 <forkforkfork+0x8a>
  sleep(20); // two seconds
    1a44:	4551                	li	a0,20
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	9f2080e7          	jalr	-1550(ra) # 5438 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    1a4e:	20200593          	li	a1,514
    1a52:	00004517          	auipc	a0,0x4
    1a56:	4a650513          	addi	a0,a0,1190 # 5ef8 <malloc+0x70a>
    1a5a:	00004097          	auipc	ra,0x4
    1a5e:	98e080e7          	jalr	-1650(ra) # 53e8 <open>
    1a62:	00004097          	auipc	ra,0x4
    1a66:	96e080e7          	jalr	-1682(ra) # 53d0 <close>
  wait(0);
    1a6a:	4501                	li	a0,0
    1a6c:	00004097          	auipc	ra,0x4
    1a70:	944080e7          	jalr	-1724(ra) # 53b0 <wait>
  sleep(10); // one second
    1a74:	4529                	li	a0,10
    1a76:	00004097          	auipc	ra,0x4
    1a7a:	9c2080e7          	jalr	-1598(ra) # 5438 <sleep>
}
    1a7e:	60e2                	ld	ra,24(sp)
    1a80:	6442                	ld	s0,16(sp)
    1a82:	64a2                	ld	s1,8(sp)
    1a84:	6105                	addi	sp,sp,32
    1a86:	8082                	ret
    printf("%s: fork failed", s);
    1a88:	85a6                	mv	a1,s1
    1a8a:	00004517          	auipc	a0,0x4
    1a8e:	2ce50513          	addi	a0,a0,718 # 5d58 <malloc+0x56a>
    1a92:	00004097          	auipc	ra,0x4
    1a96:	c9e080e7          	jalr	-866(ra) # 5730 <printf>
    exit(1);
    1a9a:	4505                	li	a0,1
    1a9c:	00004097          	auipc	ra,0x4
    1aa0:	90c080e7          	jalr	-1780(ra) # 53a8 <exit>
      int fd = open("stopforking", 0);
    1aa4:	00004497          	auipc	s1,0x4
    1aa8:	45448493          	addi	s1,s1,1108 # 5ef8 <malloc+0x70a>
    1aac:	4581                	li	a1,0
    1aae:	8526                	mv	a0,s1
    1ab0:	00004097          	auipc	ra,0x4
    1ab4:	938080e7          	jalr	-1736(ra) # 53e8 <open>
      if(fd >= 0){
    1ab8:	02055463          	bgez	a0,1ae0 <forkforkfork+0xc6>
      if(fork() < 0){
    1abc:	00004097          	auipc	ra,0x4
    1ac0:	8e4080e7          	jalr	-1820(ra) # 53a0 <fork>
    1ac4:	fe0554e3          	bgez	a0,1aac <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    1ac8:	20200593          	li	a1,514
    1acc:	8526                	mv	a0,s1
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	91a080e7          	jalr	-1766(ra) # 53e8 <open>
    1ad6:	00004097          	auipc	ra,0x4
    1ada:	8fa080e7          	jalr	-1798(ra) # 53d0 <close>
    1ade:	b7f9                	j	1aac <forkforkfork+0x92>
        exit(0);
    1ae0:	4501                	li	a0,0
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	8c6080e7          	jalr	-1850(ra) # 53a8 <exit>

0000000000001aea <createdelete>:
{
    1aea:	7175                	addi	sp,sp,-144
    1aec:	e506                	sd	ra,136(sp)
    1aee:	e122                	sd	s0,128(sp)
    1af0:	fca6                	sd	s1,120(sp)
    1af2:	f8ca                	sd	s2,112(sp)
    1af4:	f4ce                	sd	s3,104(sp)
    1af6:	f0d2                	sd	s4,96(sp)
    1af8:	ecd6                	sd	s5,88(sp)
    1afa:	e8da                	sd	s6,80(sp)
    1afc:	e4de                	sd	s7,72(sp)
    1afe:	e0e2                	sd	s8,64(sp)
    1b00:	fc66                	sd	s9,56(sp)
    1b02:	0900                	addi	s0,sp,144
    1b04:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1b06:	4901                	li	s2,0
    1b08:	4991                	li	s3,4
    pid = fork();
    1b0a:	00004097          	auipc	ra,0x4
    1b0e:	896080e7          	jalr	-1898(ra) # 53a0 <fork>
    1b12:	84aa                	mv	s1,a0
    if(pid < 0){
    1b14:	02054f63          	bltz	a0,1b52 <createdelete+0x68>
    if(pid == 0){
    1b18:	c939                	beqz	a0,1b6e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1b1a:	2905                	addiw	s2,s2,1
    1b1c:	ff3917e3          	bne	s2,s3,1b0a <createdelete+0x20>
    1b20:	4491                	li	s1,4
    wait(&xstatus);
    1b22:	f7c40513          	addi	a0,s0,-132
    1b26:	00004097          	auipc	ra,0x4
    1b2a:	88a080e7          	jalr	-1910(ra) # 53b0 <wait>
    if(xstatus != 0)
    1b2e:	f7c42903          	lw	s2,-132(s0)
    1b32:	0e091263          	bnez	s2,1c16 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1b36:	34fd                	addiw	s1,s1,-1
    1b38:	f4ed                	bnez	s1,1b22 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1b3a:	f8040123          	sb	zero,-126(s0)
    1b3e:	03000993          	li	s3,48
    1b42:	5a7d                	li	s4,-1
    1b44:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1b48:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1b4a:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1b4c:	07400a93          	li	s5,116
    1b50:	a29d                	j	1cb6 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1b52:	85e6                	mv	a1,s9
    1b54:	00005517          	auipc	a0,0x5
    1b58:	a9c50513          	addi	a0,a0,-1380 # 65f0 <malloc+0xe02>
    1b5c:	00004097          	auipc	ra,0x4
    1b60:	bd4080e7          	jalr	-1068(ra) # 5730 <printf>
      exit(1);
    1b64:	4505                	li	a0,1
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	842080e7          	jalr	-1982(ra) # 53a8 <exit>
      name[0] = 'p' + pi;
    1b6e:	0709091b          	addiw	s2,s2,112
    1b72:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1b76:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1b7a:	4951                	li	s2,20
    1b7c:	a015                	j	1ba0 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1b7e:	85e6                	mv	a1,s9
    1b80:	00004517          	auipc	a0,0x4
    1b84:	38850513          	addi	a0,a0,904 # 5f08 <malloc+0x71a>
    1b88:	00004097          	auipc	ra,0x4
    1b8c:	ba8080e7          	jalr	-1112(ra) # 5730 <printf>
          exit(1);
    1b90:	4505                	li	a0,1
    1b92:	00004097          	auipc	ra,0x4
    1b96:	816080e7          	jalr	-2026(ra) # 53a8 <exit>
      for(i = 0; i < N; i++){
    1b9a:	2485                	addiw	s1,s1,1
    1b9c:	07248863          	beq	s1,s2,1c0c <createdelete+0x122>
        name[1] = '0' + i;
    1ba0:	0304879b          	addiw	a5,s1,48
    1ba4:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1ba8:	20200593          	li	a1,514
    1bac:	f8040513          	addi	a0,s0,-128
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	838080e7          	jalr	-1992(ra) # 53e8 <open>
        if(fd < 0){
    1bb8:	fc0543e3          	bltz	a0,1b7e <createdelete+0x94>
        close(fd);
    1bbc:	00004097          	auipc	ra,0x4
    1bc0:	814080e7          	jalr	-2028(ra) # 53d0 <close>
        if(i > 0 && (i % 2 ) == 0){
    1bc4:	fc905be3          	blez	s1,1b9a <createdelete+0xb0>
    1bc8:	0014f793          	andi	a5,s1,1
    1bcc:	f7f9                	bnez	a5,1b9a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1bce:	01f4d79b          	srliw	a5,s1,0x1f
    1bd2:	9fa5                	addw	a5,a5,s1
    1bd4:	4017d79b          	sraiw	a5,a5,0x1
    1bd8:	0307879b          	addiw	a5,a5,48
    1bdc:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1be0:	f8040513          	addi	a0,s0,-128
    1be4:	00004097          	auipc	ra,0x4
    1be8:	814080e7          	jalr	-2028(ra) # 53f8 <unlink>
    1bec:	fa0557e3          	bgez	a0,1b9a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1bf0:	85e6                	mv	a1,s9
    1bf2:	00004517          	auipc	a0,0x4
    1bf6:	29650513          	addi	a0,a0,662 # 5e88 <malloc+0x69a>
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	b36080e7          	jalr	-1226(ra) # 5730 <printf>
            exit(1);
    1c02:	4505                	li	a0,1
    1c04:	00003097          	auipc	ra,0x3
    1c08:	7a4080e7          	jalr	1956(ra) # 53a8 <exit>
      exit(0);
    1c0c:	4501                	li	a0,0
    1c0e:	00003097          	auipc	ra,0x3
    1c12:	79a080e7          	jalr	1946(ra) # 53a8 <exit>
      exit(1);
    1c16:	4505                	li	a0,1
    1c18:	00003097          	auipc	ra,0x3
    1c1c:	790080e7          	jalr	1936(ra) # 53a8 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1c20:	f8040613          	addi	a2,s0,-128
    1c24:	85e6                	mv	a1,s9
    1c26:	00004517          	auipc	a0,0x4
    1c2a:	2fa50513          	addi	a0,a0,762 # 5f20 <malloc+0x732>
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	b02080e7          	jalr	-1278(ra) # 5730 <printf>
        exit(1);
    1c36:	4505                	li	a0,1
    1c38:	00003097          	auipc	ra,0x3
    1c3c:	770080e7          	jalr	1904(ra) # 53a8 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c40:	054b7163          	bgeu	s6,s4,1c82 <createdelete+0x198>
      if(fd >= 0)
    1c44:	02055a63          	bgez	a0,1c78 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1c48:	2485                	addiw	s1,s1,1
    1c4a:	0ff4f493          	andi	s1,s1,255
    1c4e:	05548c63          	beq	s1,s5,1ca6 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1c52:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1c56:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1c5a:	4581                	li	a1,0
    1c5c:	f8040513          	addi	a0,s0,-128
    1c60:	00003097          	auipc	ra,0x3
    1c64:	788080e7          	jalr	1928(ra) # 53e8 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1c68:	00090463          	beqz	s2,1c70 <createdelete+0x186>
    1c6c:	fd2bdae3          	bge	s7,s2,1c40 <createdelete+0x156>
    1c70:	fa0548e3          	bltz	a0,1c20 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c74:	014b7963          	bgeu	s6,s4,1c86 <createdelete+0x19c>
        close(fd);
    1c78:	00003097          	auipc	ra,0x3
    1c7c:	758080e7          	jalr	1880(ra) # 53d0 <close>
    1c80:	b7e1                	j	1c48 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c82:	fc0543e3          	bltz	a0,1c48 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1c86:	f8040613          	addi	a2,s0,-128
    1c8a:	85e6                	mv	a1,s9
    1c8c:	00004517          	auipc	a0,0x4
    1c90:	2bc50513          	addi	a0,a0,700 # 5f48 <malloc+0x75a>
    1c94:	00004097          	auipc	ra,0x4
    1c98:	a9c080e7          	jalr	-1380(ra) # 5730 <printf>
        exit(1);
    1c9c:	4505                	li	a0,1
    1c9e:	00003097          	auipc	ra,0x3
    1ca2:	70a080e7          	jalr	1802(ra) # 53a8 <exit>
  for(i = 0; i < N; i++){
    1ca6:	2905                	addiw	s2,s2,1
    1ca8:	2a05                	addiw	s4,s4,1
    1caa:	2985                	addiw	s3,s3,1
    1cac:	0ff9f993          	andi	s3,s3,255
    1cb0:	47d1                	li	a5,20
    1cb2:	02f90a63          	beq	s2,a5,1ce6 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1cb6:	84e2                	mv	s1,s8
    1cb8:	bf69                	j	1c52 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1cba:	2905                	addiw	s2,s2,1
    1cbc:	0ff97913          	andi	s2,s2,255
    1cc0:	2985                	addiw	s3,s3,1
    1cc2:	0ff9f993          	andi	s3,s3,255
    1cc6:	03490863          	beq	s2,s4,1cf6 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1cca:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1ccc:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1cd0:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1cd4:	f8040513          	addi	a0,s0,-128
    1cd8:	00003097          	auipc	ra,0x3
    1cdc:	720080e7          	jalr	1824(ra) # 53f8 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1ce0:	34fd                	addiw	s1,s1,-1
    1ce2:	f4ed                	bnez	s1,1ccc <createdelete+0x1e2>
    1ce4:	bfd9                	j	1cba <createdelete+0x1d0>
    1ce6:	03000993          	li	s3,48
    1cea:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1cee:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1cf0:	08400a13          	li	s4,132
    1cf4:	bfd9                	j	1cca <createdelete+0x1e0>
}
    1cf6:	60aa                	ld	ra,136(sp)
    1cf8:	640a                	ld	s0,128(sp)
    1cfa:	74e6                	ld	s1,120(sp)
    1cfc:	7946                	ld	s2,112(sp)
    1cfe:	79a6                	ld	s3,104(sp)
    1d00:	7a06                	ld	s4,96(sp)
    1d02:	6ae6                	ld	s5,88(sp)
    1d04:	6b46                	ld	s6,80(sp)
    1d06:	6ba6                	ld	s7,72(sp)
    1d08:	6c06                	ld	s8,64(sp)
    1d0a:	7ce2                	ld	s9,56(sp)
    1d0c:	6149                	addi	sp,sp,144
    1d0e:	8082                	ret

0000000000001d10 <fourteen>:
{
    1d10:	1101                	addi	sp,sp,-32
    1d12:	ec06                	sd	ra,24(sp)
    1d14:	e822                	sd	s0,16(sp)
    1d16:	e426                	sd	s1,8(sp)
    1d18:	1000                	addi	s0,sp,32
    1d1a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    1d1c:	00004517          	auipc	a0,0x4
    1d20:	42450513          	addi	a0,a0,1060 # 6140 <malloc+0x952>
    1d24:	00003097          	auipc	ra,0x3
    1d28:	6ec080e7          	jalr	1772(ra) # 5410 <mkdir>
    1d2c:	e141                	bnez	a0,1dac <fourteen+0x9c>
  if(mkdir("12345678901234/123456789012345") != 0){
    1d2e:	00004517          	auipc	a0,0x4
    1d32:	26a50513          	addi	a0,a0,618 # 5f98 <malloc+0x7aa>
    1d36:	00003097          	auipc	ra,0x3
    1d3a:	6da080e7          	jalr	1754(ra) # 5410 <mkdir>
    1d3e:	e549                	bnez	a0,1dc8 <fourteen+0xb8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    1d40:	20000593          	li	a1,512
    1d44:	00004517          	auipc	a0,0x4
    1d48:	2ac50513          	addi	a0,a0,684 # 5ff0 <malloc+0x802>
    1d4c:	00003097          	auipc	ra,0x3
    1d50:	69c080e7          	jalr	1692(ra) # 53e8 <open>
  if(fd < 0){
    1d54:	08054863          	bltz	a0,1de4 <fourteen+0xd4>
  close(fd);
    1d58:	00003097          	auipc	ra,0x3
    1d5c:	678080e7          	jalr	1656(ra) # 53d0 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    1d60:	4581                	li	a1,0
    1d62:	00004517          	auipc	a0,0x4
    1d66:	30650513          	addi	a0,a0,774 # 6068 <malloc+0x87a>
    1d6a:	00003097          	auipc	ra,0x3
    1d6e:	67e080e7          	jalr	1662(ra) # 53e8 <open>
  if(fd < 0){
    1d72:	08054763          	bltz	a0,1e00 <fourteen+0xf0>
  close(fd);
    1d76:	00003097          	auipc	ra,0x3
    1d7a:	65a080e7          	jalr	1626(ra) # 53d0 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    1d7e:	00004517          	auipc	a0,0x4
    1d82:	35a50513          	addi	a0,a0,858 # 60d8 <malloc+0x8ea>
    1d86:	00003097          	auipc	ra,0x3
    1d8a:	68a080e7          	jalr	1674(ra) # 5410 <mkdir>
    1d8e:	c559                	beqz	a0,1e1c <fourteen+0x10c>
  if(mkdir("123456789012345/12345678901234") == 0){
    1d90:	00004517          	auipc	a0,0x4
    1d94:	3a050513          	addi	a0,a0,928 # 6130 <malloc+0x942>
    1d98:	00003097          	auipc	ra,0x3
    1d9c:	678080e7          	jalr	1656(ra) # 5410 <mkdir>
    1da0:	cd41                	beqz	a0,1e38 <fourteen+0x128>
}
    1da2:	60e2                	ld	ra,24(sp)
    1da4:	6442                	ld	s0,16(sp)
    1da6:	64a2                	ld	s1,8(sp)
    1da8:	6105                	addi	sp,sp,32
    1daa:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    1dac:	85a6                	mv	a1,s1
    1dae:	00004517          	auipc	a0,0x4
    1db2:	1c250513          	addi	a0,a0,450 # 5f70 <malloc+0x782>
    1db6:	00004097          	auipc	ra,0x4
    1dba:	97a080e7          	jalr	-1670(ra) # 5730 <printf>
    exit(1);
    1dbe:	4505                	li	a0,1
    1dc0:	00003097          	auipc	ra,0x3
    1dc4:	5e8080e7          	jalr	1512(ra) # 53a8 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    1dc8:	85a6                	mv	a1,s1
    1dca:	00004517          	auipc	a0,0x4
    1dce:	1ee50513          	addi	a0,a0,494 # 5fb8 <malloc+0x7ca>
    1dd2:	00004097          	auipc	ra,0x4
    1dd6:	95e080e7          	jalr	-1698(ra) # 5730 <printf>
    exit(1);
    1dda:	4505                	li	a0,1
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	5cc080e7          	jalr	1484(ra) # 53a8 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    1de4:	85a6                	mv	a1,s1
    1de6:	00004517          	auipc	a0,0x4
    1dea:	23a50513          	addi	a0,a0,570 # 6020 <malloc+0x832>
    1dee:	00004097          	auipc	ra,0x4
    1df2:	942080e7          	jalr	-1726(ra) # 5730 <printf>
    exit(1);
    1df6:	4505                	li	a0,1
    1df8:	00003097          	auipc	ra,0x3
    1dfc:	5b0080e7          	jalr	1456(ra) # 53a8 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    1e00:	85a6                	mv	a1,s1
    1e02:	00004517          	auipc	a0,0x4
    1e06:	29650513          	addi	a0,a0,662 # 6098 <malloc+0x8aa>
    1e0a:	00004097          	auipc	ra,0x4
    1e0e:	926080e7          	jalr	-1754(ra) # 5730 <printf>
    exit(1);
    1e12:	4505                	li	a0,1
    1e14:	00003097          	auipc	ra,0x3
    1e18:	594080e7          	jalr	1428(ra) # 53a8 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    1e1c:	85a6                	mv	a1,s1
    1e1e:	00004517          	auipc	a0,0x4
    1e22:	2da50513          	addi	a0,a0,730 # 60f8 <malloc+0x90a>
    1e26:	00004097          	auipc	ra,0x4
    1e2a:	90a080e7          	jalr	-1782(ra) # 5730 <printf>
    exit(1);
    1e2e:	4505                	li	a0,1
    1e30:	00003097          	auipc	ra,0x3
    1e34:	578080e7          	jalr	1400(ra) # 53a8 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    1e38:	85a6                	mv	a1,s1
    1e3a:	00004517          	auipc	a0,0x4
    1e3e:	31650513          	addi	a0,a0,790 # 6150 <malloc+0x962>
    1e42:	00004097          	auipc	ra,0x4
    1e46:	8ee080e7          	jalr	-1810(ra) # 5730 <printf>
    exit(1);
    1e4a:	4505                	li	a0,1
    1e4c:	00003097          	auipc	ra,0x3
    1e50:	55c080e7          	jalr	1372(ra) # 53a8 <exit>

0000000000001e54 <bigwrite>:
{
    1e54:	715d                	addi	sp,sp,-80
    1e56:	e486                	sd	ra,72(sp)
    1e58:	e0a2                	sd	s0,64(sp)
    1e5a:	fc26                	sd	s1,56(sp)
    1e5c:	f84a                	sd	s2,48(sp)
    1e5e:	f44e                	sd	s3,40(sp)
    1e60:	f052                	sd	s4,32(sp)
    1e62:	ec56                	sd	s5,24(sp)
    1e64:	e85a                	sd	s6,16(sp)
    1e66:	e45e                	sd	s7,8(sp)
    1e68:	0880                	addi	s0,sp,80
    1e6a:	8baa                	mv	s7,a0
  unlink("bigwrite");
    1e6c:	00004517          	auipc	a0,0x4
    1e70:	ba450513          	addi	a0,a0,-1116 # 5a10 <malloc+0x222>
    1e74:	00003097          	auipc	ra,0x3
    1e78:	584080e7          	jalr	1412(ra) # 53f8 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    1e7c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
    1e80:	00004a97          	auipc	s5,0x4
    1e84:	b90a8a93          	addi	s5,s5,-1136 # 5a10 <malloc+0x222>
      int cc = write(fd, buf, sz);
    1e88:	00008a17          	auipc	s4,0x8
    1e8c:	328a0a13          	addi	s4,s4,808 # a1b0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    1e90:	6b0d                	lui	s6,0x3
    1e92:	1c9b0b13          	addi	s6,s6,457 # 31c9 <bigfile+0x195>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    1e96:	20200593          	li	a1,514
    1e9a:	8556                	mv	a0,s5
    1e9c:	00003097          	auipc	ra,0x3
    1ea0:	54c080e7          	jalr	1356(ra) # 53e8 <open>
    1ea4:	892a                	mv	s2,a0
    if(fd < 0){
    1ea6:	04054d63          	bltz	a0,1f00 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
    1eaa:	8626                	mv	a2,s1
    1eac:	85d2                	mv	a1,s4
    1eae:	00003097          	auipc	ra,0x3
    1eb2:	51a080e7          	jalr	1306(ra) # 53c8 <write>
    1eb6:	89aa                	mv	s3,a0
      if(cc != sz){
    1eb8:	06a49463          	bne	s1,a0,1f20 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
    1ebc:	8626                	mv	a2,s1
    1ebe:	85d2                	mv	a1,s4
    1ec0:	854a                	mv	a0,s2
    1ec2:	00003097          	auipc	ra,0x3
    1ec6:	506080e7          	jalr	1286(ra) # 53c8 <write>
      if(cc != sz){
    1eca:	04951963          	bne	a0,s1,1f1c <bigwrite+0xc8>
    close(fd);
    1ece:	854a                	mv	a0,s2
    1ed0:	00003097          	auipc	ra,0x3
    1ed4:	500080e7          	jalr	1280(ra) # 53d0 <close>
    unlink("bigwrite");
    1ed8:	8556                	mv	a0,s5
    1eda:	00003097          	auipc	ra,0x3
    1ede:	51e080e7          	jalr	1310(ra) # 53f8 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    1ee2:	1d74849b          	addiw	s1,s1,471
    1ee6:	fb6498e3          	bne	s1,s6,1e96 <bigwrite+0x42>
}
    1eea:	60a6                	ld	ra,72(sp)
    1eec:	6406                	ld	s0,64(sp)
    1eee:	74e2                	ld	s1,56(sp)
    1ef0:	7942                	ld	s2,48(sp)
    1ef2:	79a2                	ld	s3,40(sp)
    1ef4:	7a02                	ld	s4,32(sp)
    1ef6:	6ae2                	ld	s5,24(sp)
    1ef8:	6b42                	ld	s6,16(sp)
    1efa:	6ba2                	ld	s7,8(sp)
    1efc:	6161                	addi	sp,sp,80
    1efe:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
    1f00:	85de                	mv	a1,s7
    1f02:	00004517          	auipc	a0,0x4
    1f06:	28650513          	addi	a0,a0,646 # 6188 <malloc+0x99a>
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	826080e7          	jalr	-2010(ra) # 5730 <printf>
      exit(1);
    1f12:	4505                	li	a0,1
    1f14:	00003097          	auipc	ra,0x3
    1f18:	494080e7          	jalr	1172(ra) # 53a8 <exit>
    1f1c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
    1f1e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
    1f20:	86ce                	mv	a3,s3
    1f22:	8626                	mv	a2,s1
    1f24:	85de                	mv	a1,s7
    1f26:	00004517          	auipc	a0,0x4
    1f2a:	28250513          	addi	a0,a0,642 # 61a8 <malloc+0x9ba>
    1f2e:	00004097          	auipc	ra,0x4
    1f32:	802080e7          	jalr	-2046(ra) # 5730 <printf>
        exit(1);
    1f36:	4505                	li	a0,1
    1f38:	00003097          	auipc	ra,0x3
    1f3c:	470080e7          	jalr	1136(ra) # 53a8 <exit>

0000000000001f40 <writetest>:
{
    1f40:	7139                	addi	sp,sp,-64
    1f42:	fc06                	sd	ra,56(sp)
    1f44:	f822                	sd	s0,48(sp)
    1f46:	f426                	sd	s1,40(sp)
    1f48:	f04a                	sd	s2,32(sp)
    1f4a:	ec4e                	sd	s3,24(sp)
    1f4c:	e852                	sd	s4,16(sp)
    1f4e:	e456                	sd	s5,8(sp)
    1f50:	e05a                	sd	s6,0(sp)
    1f52:	0080                	addi	s0,sp,64
    1f54:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
    1f56:	20200593          	li	a1,514
    1f5a:	00004517          	auipc	a0,0x4
    1f5e:	26650513          	addi	a0,a0,614 # 61c0 <malloc+0x9d2>
    1f62:	00003097          	auipc	ra,0x3
    1f66:	486080e7          	jalr	1158(ra) # 53e8 <open>
  if(fd < 0){
    1f6a:	0a054d63          	bltz	a0,2024 <writetest+0xe4>
    1f6e:	892a                	mv	s2,a0
    1f70:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    1f72:	00004997          	auipc	s3,0x4
    1f76:	27698993          	addi	s3,s3,630 # 61e8 <malloc+0x9fa>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    1f7a:	00004a97          	auipc	s5,0x4
    1f7e:	2a6a8a93          	addi	s5,s5,678 # 6220 <malloc+0xa32>
  for(i = 0; i < N; i++){
    1f82:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    1f86:	4629                	li	a2,10
    1f88:	85ce                	mv	a1,s3
    1f8a:	854a                	mv	a0,s2
    1f8c:	00003097          	auipc	ra,0x3
    1f90:	43c080e7          	jalr	1084(ra) # 53c8 <write>
    1f94:	47a9                	li	a5,10
    1f96:	0af51563          	bne	a0,a5,2040 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    1f9a:	4629                	li	a2,10
    1f9c:	85d6                	mv	a1,s5
    1f9e:	854a                	mv	a0,s2
    1fa0:	00003097          	auipc	ra,0x3
    1fa4:	428080e7          	jalr	1064(ra) # 53c8 <write>
    1fa8:	47a9                	li	a5,10
    1faa:	0af51963          	bne	a0,a5,205c <writetest+0x11c>
  for(i = 0; i < N; i++){
    1fae:	2485                	addiw	s1,s1,1
    1fb0:	fd449be3          	bne	s1,s4,1f86 <writetest+0x46>
  close(fd);
    1fb4:	854a                	mv	a0,s2
    1fb6:	00003097          	auipc	ra,0x3
    1fba:	41a080e7          	jalr	1050(ra) # 53d0 <close>
  fd = open("small", O_RDONLY);
    1fbe:	4581                	li	a1,0
    1fc0:	00004517          	auipc	a0,0x4
    1fc4:	20050513          	addi	a0,a0,512 # 61c0 <malloc+0x9d2>
    1fc8:	00003097          	auipc	ra,0x3
    1fcc:	420080e7          	jalr	1056(ra) # 53e8 <open>
    1fd0:	84aa                	mv	s1,a0
  if(fd < 0){
    1fd2:	0a054363          	bltz	a0,2078 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
    1fd6:	7d000613          	li	a2,2000
    1fda:	00008597          	auipc	a1,0x8
    1fde:	1d658593          	addi	a1,a1,470 # a1b0 <buf>
    1fe2:	00003097          	auipc	ra,0x3
    1fe6:	3de080e7          	jalr	990(ra) # 53c0 <read>
  if(i != N*SZ*2){
    1fea:	7d000793          	li	a5,2000
    1fee:	0af51363          	bne	a0,a5,2094 <writetest+0x154>
  close(fd);
    1ff2:	8526                	mv	a0,s1
    1ff4:	00003097          	auipc	ra,0x3
    1ff8:	3dc080e7          	jalr	988(ra) # 53d0 <close>
  if(unlink("small") < 0){
    1ffc:	00004517          	auipc	a0,0x4
    2000:	1c450513          	addi	a0,a0,452 # 61c0 <malloc+0x9d2>
    2004:	00003097          	auipc	ra,0x3
    2008:	3f4080e7          	jalr	1012(ra) # 53f8 <unlink>
    200c:	0a054263          	bltz	a0,20b0 <writetest+0x170>
}
    2010:	70e2                	ld	ra,56(sp)
    2012:	7442                	ld	s0,48(sp)
    2014:	74a2                	ld	s1,40(sp)
    2016:	7902                	ld	s2,32(sp)
    2018:	69e2                	ld	s3,24(sp)
    201a:	6a42                	ld	s4,16(sp)
    201c:	6aa2                	ld	s5,8(sp)
    201e:	6b02                	ld	s6,0(sp)
    2020:	6121                	addi	sp,sp,64
    2022:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    2024:	85da                	mv	a1,s6
    2026:	00004517          	auipc	a0,0x4
    202a:	1a250513          	addi	a0,a0,418 # 61c8 <malloc+0x9da>
    202e:	00003097          	auipc	ra,0x3
    2032:	702080e7          	jalr	1794(ra) # 5730 <printf>
    exit(1);
    2036:	4505                	li	a0,1
    2038:	00003097          	auipc	ra,0x3
    203c:	370080e7          	jalr	880(ra) # 53a8 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
    2040:	85a6                	mv	a1,s1
    2042:	00004517          	auipc	a0,0x4
    2046:	1b650513          	addi	a0,a0,438 # 61f8 <malloc+0xa0a>
    204a:	00003097          	auipc	ra,0x3
    204e:	6e6080e7          	jalr	1766(ra) # 5730 <printf>
      exit(1);
    2052:	4505                	li	a0,1
    2054:	00003097          	auipc	ra,0x3
    2058:	354080e7          	jalr	852(ra) # 53a8 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
    205c:	85a6                	mv	a1,s1
    205e:	00004517          	auipc	a0,0x4
    2062:	1d250513          	addi	a0,a0,466 # 6230 <malloc+0xa42>
    2066:	00003097          	auipc	ra,0x3
    206a:	6ca080e7          	jalr	1738(ra) # 5730 <printf>
      exit(1);
    206e:	4505                	li	a0,1
    2070:	00003097          	auipc	ra,0x3
    2074:	338080e7          	jalr	824(ra) # 53a8 <exit>
    printf("%s: error: open small failed!\n", s);
    2078:	85da                	mv	a1,s6
    207a:	00004517          	auipc	a0,0x4
    207e:	1de50513          	addi	a0,a0,478 # 6258 <malloc+0xa6a>
    2082:	00003097          	auipc	ra,0x3
    2086:	6ae080e7          	jalr	1710(ra) # 5730 <printf>
    exit(1);
    208a:	4505                	li	a0,1
    208c:	00003097          	auipc	ra,0x3
    2090:	31c080e7          	jalr	796(ra) # 53a8 <exit>
    printf("%s: read failed\n", s);
    2094:	85da                	mv	a1,s6
    2096:	00004517          	auipc	a0,0x4
    209a:	1e250513          	addi	a0,a0,482 # 6278 <malloc+0xa8a>
    209e:	00003097          	auipc	ra,0x3
    20a2:	692080e7          	jalr	1682(ra) # 5730 <printf>
    exit(1);
    20a6:	4505                	li	a0,1
    20a8:	00003097          	auipc	ra,0x3
    20ac:	300080e7          	jalr	768(ra) # 53a8 <exit>
    printf("%s: unlink small failed\n", s);
    20b0:	85da                	mv	a1,s6
    20b2:	00004517          	auipc	a0,0x4
    20b6:	1de50513          	addi	a0,a0,478 # 6290 <malloc+0xaa2>
    20ba:	00003097          	auipc	ra,0x3
    20be:	676080e7          	jalr	1654(ra) # 5730 <printf>
    exit(1);
    20c2:	4505                	li	a0,1
    20c4:	00003097          	auipc	ra,0x3
    20c8:	2e4080e7          	jalr	740(ra) # 53a8 <exit>

00000000000020cc <writebig>:
{
    20cc:	7139                	addi	sp,sp,-64
    20ce:	fc06                	sd	ra,56(sp)
    20d0:	f822                	sd	s0,48(sp)
    20d2:	f426                	sd	s1,40(sp)
    20d4:	f04a                	sd	s2,32(sp)
    20d6:	ec4e                	sd	s3,24(sp)
    20d8:	e852                	sd	s4,16(sp)
    20da:	e456                	sd	s5,8(sp)
    20dc:	0080                	addi	s0,sp,64
    20de:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    20e0:	20200593          	li	a1,514
    20e4:	00004517          	auipc	a0,0x4
    20e8:	1cc50513          	addi	a0,a0,460 # 62b0 <malloc+0xac2>
    20ec:	00003097          	auipc	ra,0x3
    20f0:	2fc080e7          	jalr	764(ra) # 53e8 <open>
    20f4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
    20f6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    20f8:	00008917          	auipc	s2,0x8
    20fc:	0b890913          	addi	s2,s2,184 # a1b0 <buf>
  for(i = 0; i < MAXFILE; i++){
    2100:	10c00a13          	li	s4,268
  if(fd < 0){
    2104:	06054c63          	bltz	a0,217c <writebig+0xb0>
    ((int*)buf)[0] = i;
    2108:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    210c:	40000613          	li	a2,1024
    2110:	85ca                	mv	a1,s2
    2112:	854e                	mv	a0,s3
    2114:	00003097          	auipc	ra,0x3
    2118:	2b4080e7          	jalr	692(ra) # 53c8 <write>
    211c:	40000793          	li	a5,1024
    2120:	06f51c63          	bne	a0,a5,2198 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
    2124:	2485                	addiw	s1,s1,1
    2126:	ff4491e3          	bne	s1,s4,2108 <writebig+0x3c>
  close(fd);
    212a:	854e                	mv	a0,s3
    212c:	00003097          	auipc	ra,0x3
    2130:	2a4080e7          	jalr	676(ra) # 53d0 <close>
  fd = open("big", O_RDONLY);
    2134:	4581                	li	a1,0
    2136:	00004517          	auipc	a0,0x4
    213a:	17a50513          	addi	a0,a0,378 # 62b0 <malloc+0xac2>
    213e:	00003097          	auipc	ra,0x3
    2142:	2aa080e7          	jalr	682(ra) # 53e8 <open>
    2146:	89aa                	mv	s3,a0
  n = 0;
    2148:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    214a:	00008917          	auipc	s2,0x8
    214e:	06690913          	addi	s2,s2,102 # a1b0 <buf>
  if(fd < 0){
    2152:	06054163          	bltz	a0,21b4 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
    2156:	40000613          	li	a2,1024
    215a:	85ca                	mv	a1,s2
    215c:	854e                	mv	a0,s3
    215e:	00003097          	auipc	ra,0x3
    2162:	262080e7          	jalr	610(ra) # 53c0 <read>
    if(i == 0){
    2166:	c52d                	beqz	a0,21d0 <writebig+0x104>
    } else if(i != BSIZE){
    2168:	40000793          	li	a5,1024
    216c:	0af51d63          	bne	a0,a5,2226 <writebig+0x15a>
    if(((int*)buf)[0] != n){
    2170:	00092603          	lw	a2,0(s2)
    2174:	0c961763          	bne	a2,s1,2242 <writebig+0x176>
    n++;
    2178:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    217a:	bff1                	j	2156 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
    217c:	85d6                	mv	a1,s5
    217e:	00004517          	auipc	a0,0x4
    2182:	13a50513          	addi	a0,a0,314 # 62b8 <malloc+0xaca>
    2186:	00003097          	auipc	ra,0x3
    218a:	5aa080e7          	jalr	1450(ra) # 5730 <printf>
    exit(1);
    218e:	4505                	li	a0,1
    2190:	00003097          	auipc	ra,0x3
    2194:	218080e7          	jalr	536(ra) # 53a8 <exit>
      printf("%s: error: write big file failed\n", i);
    2198:	85a6                	mv	a1,s1
    219a:	00004517          	auipc	a0,0x4
    219e:	13e50513          	addi	a0,a0,318 # 62d8 <malloc+0xaea>
    21a2:	00003097          	auipc	ra,0x3
    21a6:	58e080e7          	jalr	1422(ra) # 5730 <printf>
      exit(1);
    21aa:	4505                	li	a0,1
    21ac:	00003097          	auipc	ra,0x3
    21b0:	1fc080e7          	jalr	508(ra) # 53a8 <exit>
    printf("%s: error: open big failed!\n", s);
    21b4:	85d6                	mv	a1,s5
    21b6:	00004517          	auipc	a0,0x4
    21ba:	14a50513          	addi	a0,a0,330 # 6300 <malloc+0xb12>
    21be:	00003097          	auipc	ra,0x3
    21c2:	572080e7          	jalr	1394(ra) # 5730 <printf>
    exit(1);
    21c6:	4505                	li	a0,1
    21c8:	00003097          	auipc	ra,0x3
    21cc:	1e0080e7          	jalr	480(ra) # 53a8 <exit>
      if(n == MAXFILE - 1){
    21d0:	10b00793          	li	a5,267
    21d4:	02f48a63          	beq	s1,a5,2208 <writebig+0x13c>
  close(fd);
    21d8:	854e                	mv	a0,s3
    21da:	00003097          	auipc	ra,0x3
    21de:	1f6080e7          	jalr	502(ra) # 53d0 <close>
  if(unlink("big") < 0){
    21e2:	00004517          	auipc	a0,0x4
    21e6:	0ce50513          	addi	a0,a0,206 # 62b0 <malloc+0xac2>
    21ea:	00003097          	auipc	ra,0x3
    21ee:	20e080e7          	jalr	526(ra) # 53f8 <unlink>
    21f2:	06054663          	bltz	a0,225e <writebig+0x192>
}
    21f6:	70e2                	ld	ra,56(sp)
    21f8:	7442                	ld	s0,48(sp)
    21fa:	74a2                	ld	s1,40(sp)
    21fc:	7902                	ld	s2,32(sp)
    21fe:	69e2                	ld	s3,24(sp)
    2200:	6a42                	ld	s4,16(sp)
    2202:	6aa2                	ld	s5,8(sp)
    2204:	6121                	addi	sp,sp,64
    2206:	8082                	ret
        printf("%s: read only %d blocks from big", n);
    2208:	10b00593          	li	a1,267
    220c:	00004517          	auipc	a0,0x4
    2210:	11450513          	addi	a0,a0,276 # 6320 <malloc+0xb32>
    2214:	00003097          	auipc	ra,0x3
    2218:	51c080e7          	jalr	1308(ra) # 5730 <printf>
        exit(1);
    221c:	4505                	li	a0,1
    221e:	00003097          	auipc	ra,0x3
    2222:	18a080e7          	jalr	394(ra) # 53a8 <exit>
      printf("%s: read failed %d\n", i);
    2226:	85aa                	mv	a1,a0
    2228:	00004517          	auipc	a0,0x4
    222c:	12050513          	addi	a0,a0,288 # 6348 <malloc+0xb5a>
    2230:	00003097          	auipc	ra,0x3
    2234:	500080e7          	jalr	1280(ra) # 5730 <printf>
      exit(1);
    2238:	4505                	li	a0,1
    223a:	00003097          	auipc	ra,0x3
    223e:	16e080e7          	jalr	366(ra) # 53a8 <exit>
      printf("%s: read content of block %d is %d\n",
    2242:	85a6                	mv	a1,s1
    2244:	00004517          	auipc	a0,0x4
    2248:	11c50513          	addi	a0,a0,284 # 6360 <malloc+0xb72>
    224c:	00003097          	auipc	ra,0x3
    2250:	4e4080e7          	jalr	1252(ra) # 5730 <printf>
      exit(1);
    2254:	4505                	li	a0,1
    2256:	00003097          	auipc	ra,0x3
    225a:	152080e7          	jalr	338(ra) # 53a8 <exit>
    printf("%s: unlink big failed\n", s);
    225e:	85d6                	mv	a1,s5
    2260:	00004517          	auipc	a0,0x4
    2264:	12850513          	addi	a0,a0,296 # 6388 <malloc+0xb9a>
    2268:	00003097          	auipc	ra,0x3
    226c:	4c8080e7          	jalr	1224(ra) # 5730 <printf>
    exit(1);
    2270:	4505                	li	a0,1
    2272:	00003097          	auipc	ra,0x3
    2276:	136080e7          	jalr	310(ra) # 53a8 <exit>

000000000000227a <unlinkread>:
{
    227a:	7179                	addi	sp,sp,-48
    227c:	f406                	sd	ra,40(sp)
    227e:	f022                	sd	s0,32(sp)
    2280:	ec26                	sd	s1,24(sp)
    2282:	e84a                	sd	s2,16(sp)
    2284:	e44e                	sd	s3,8(sp)
    2286:	1800                	addi	s0,sp,48
    2288:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    228a:	20200593          	li	a1,514
    228e:	00003517          	auipc	a0,0x3
    2292:	71a50513          	addi	a0,a0,1818 # 59a8 <malloc+0x1ba>
    2296:	00003097          	auipc	ra,0x3
    229a:	152080e7          	jalr	338(ra) # 53e8 <open>
  if(fd < 0){
    229e:	0e054563          	bltz	a0,2388 <unlinkread+0x10e>
    22a2:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    22a4:	4615                	li	a2,5
    22a6:	00004597          	auipc	a1,0x4
    22aa:	11a58593          	addi	a1,a1,282 # 63c0 <malloc+0xbd2>
    22ae:	00003097          	auipc	ra,0x3
    22b2:	11a080e7          	jalr	282(ra) # 53c8 <write>
  close(fd);
    22b6:	8526                	mv	a0,s1
    22b8:	00003097          	auipc	ra,0x3
    22bc:	118080e7          	jalr	280(ra) # 53d0 <close>
  fd = open("unlinkread", O_RDWR);
    22c0:	4589                	li	a1,2
    22c2:	00003517          	auipc	a0,0x3
    22c6:	6e650513          	addi	a0,a0,1766 # 59a8 <malloc+0x1ba>
    22ca:	00003097          	auipc	ra,0x3
    22ce:	11e080e7          	jalr	286(ra) # 53e8 <open>
    22d2:	84aa                	mv	s1,a0
  if(fd < 0){
    22d4:	0c054863          	bltz	a0,23a4 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
    22d8:	00003517          	auipc	a0,0x3
    22dc:	6d050513          	addi	a0,a0,1744 # 59a8 <malloc+0x1ba>
    22e0:	00003097          	auipc	ra,0x3
    22e4:	118080e7          	jalr	280(ra) # 53f8 <unlink>
    22e8:	ed61                	bnez	a0,23c0 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    22ea:	20200593          	li	a1,514
    22ee:	00003517          	auipc	a0,0x3
    22f2:	6ba50513          	addi	a0,a0,1722 # 59a8 <malloc+0x1ba>
    22f6:	00003097          	auipc	ra,0x3
    22fa:	0f2080e7          	jalr	242(ra) # 53e8 <open>
    22fe:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    2300:	460d                	li	a2,3
    2302:	00004597          	auipc	a1,0x4
    2306:	10658593          	addi	a1,a1,262 # 6408 <malloc+0xc1a>
    230a:	00003097          	auipc	ra,0x3
    230e:	0be080e7          	jalr	190(ra) # 53c8 <write>
  close(fd1);
    2312:	854a                	mv	a0,s2
    2314:	00003097          	auipc	ra,0x3
    2318:	0bc080e7          	jalr	188(ra) # 53d0 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    231c:	660d                	lui	a2,0x3
    231e:	00008597          	auipc	a1,0x8
    2322:	e9258593          	addi	a1,a1,-366 # a1b0 <buf>
    2326:	8526                	mv	a0,s1
    2328:	00003097          	auipc	ra,0x3
    232c:	098080e7          	jalr	152(ra) # 53c0 <read>
    2330:	4795                	li	a5,5
    2332:	0af51563          	bne	a0,a5,23dc <unlinkread+0x162>
  if(buf[0] != 'h'){
    2336:	00008717          	auipc	a4,0x8
    233a:	e7a74703          	lbu	a4,-390(a4) # a1b0 <buf>
    233e:	06800793          	li	a5,104
    2342:	0af71b63          	bne	a4,a5,23f8 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
    2346:	4629                	li	a2,10
    2348:	00008597          	auipc	a1,0x8
    234c:	e6858593          	addi	a1,a1,-408 # a1b0 <buf>
    2350:	8526                	mv	a0,s1
    2352:	00003097          	auipc	ra,0x3
    2356:	076080e7          	jalr	118(ra) # 53c8 <write>
    235a:	47a9                	li	a5,10
    235c:	0af51c63          	bne	a0,a5,2414 <unlinkread+0x19a>
  close(fd);
    2360:	8526                	mv	a0,s1
    2362:	00003097          	auipc	ra,0x3
    2366:	06e080e7          	jalr	110(ra) # 53d0 <close>
  unlink("unlinkread");
    236a:	00003517          	auipc	a0,0x3
    236e:	63e50513          	addi	a0,a0,1598 # 59a8 <malloc+0x1ba>
    2372:	00003097          	auipc	ra,0x3
    2376:	086080e7          	jalr	134(ra) # 53f8 <unlink>
}
    237a:	70a2                	ld	ra,40(sp)
    237c:	7402                	ld	s0,32(sp)
    237e:	64e2                	ld	s1,24(sp)
    2380:	6942                	ld	s2,16(sp)
    2382:	69a2                	ld	s3,8(sp)
    2384:	6145                	addi	sp,sp,48
    2386:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    2388:	85ce                	mv	a1,s3
    238a:	00004517          	auipc	a0,0x4
    238e:	01650513          	addi	a0,a0,22 # 63a0 <malloc+0xbb2>
    2392:	00003097          	auipc	ra,0x3
    2396:	39e080e7          	jalr	926(ra) # 5730 <printf>
    exit(1);
    239a:	4505                	li	a0,1
    239c:	00003097          	auipc	ra,0x3
    23a0:	00c080e7          	jalr	12(ra) # 53a8 <exit>
    printf("%s: open unlinkread failed\n", s);
    23a4:	85ce                	mv	a1,s3
    23a6:	00004517          	auipc	a0,0x4
    23aa:	02250513          	addi	a0,a0,34 # 63c8 <malloc+0xbda>
    23ae:	00003097          	auipc	ra,0x3
    23b2:	382080e7          	jalr	898(ra) # 5730 <printf>
    exit(1);
    23b6:	4505                	li	a0,1
    23b8:	00003097          	auipc	ra,0x3
    23bc:	ff0080e7          	jalr	-16(ra) # 53a8 <exit>
    printf("%s: unlink unlinkread failed\n", s);
    23c0:	85ce                	mv	a1,s3
    23c2:	00004517          	auipc	a0,0x4
    23c6:	02650513          	addi	a0,a0,38 # 63e8 <malloc+0xbfa>
    23ca:	00003097          	auipc	ra,0x3
    23ce:	366080e7          	jalr	870(ra) # 5730 <printf>
    exit(1);
    23d2:	4505                	li	a0,1
    23d4:	00003097          	auipc	ra,0x3
    23d8:	fd4080e7          	jalr	-44(ra) # 53a8 <exit>
    printf("%s: unlinkread read failed", s);
    23dc:	85ce                	mv	a1,s3
    23de:	00004517          	auipc	a0,0x4
    23e2:	03250513          	addi	a0,a0,50 # 6410 <malloc+0xc22>
    23e6:	00003097          	auipc	ra,0x3
    23ea:	34a080e7          	jalr	842(ra) # 5730 <printf>
    exit(1);
    23ee:	4505                	li	a0,1
    23f0:	00003097          	auipc	ra,0x3
    23f4:	fb8080e7          	jalr	-72(ra) # 53a8 <exit>
    printf("%s: unlinkread wrong data\n", s);
    23f8:	85ce                	mv	a1,s3
    23fa:	00004517          	auipc	a0,0x4
    23fe:	03650513          	addi	a0,a0,54 # 6430 <malloc+0xc42>
    2402:	00003097          	auipc	ra,0x3
    2406:	32e080e7          	jalr	814(ra) # 5730 <printf>
    exit(1);
    240a:	4505                	li	a0,1
    240c:	00003097          	auipc	ra,0x3
    2410:	f9c080e7          	jalr	-100(ra) # 53a8 <exit>
    printf("%s: unlinkread write failed\n", s);
    2414:	85ce                	mv	a1,s3
    2416:	00004517          	auipc	a0,0x4
    241a:	03a50513          	addi	a0,a0,58 # 6450 <malloc+0xc62>
    241e:	00003097          	auipc	ra,0x3
    2422:	312080e7          	jalr	786(ra) # 5730 <printf>
    exit(1);
    2426:	4505                	li	a0,1
    2428:	00003097          	auipc	ra,0x3
    242c:	f80080e7          	jalr	-128(ra) # 53a8 <exit>

0000000000002430 <exectest>:
{
    2430:	715d                	addi	sp,sp,-80
    2432:	e486                	sd	ra,72(sp)
    2434:	e0a2                	sd	s0,64(sp)
    2436:	fc26                	sd	s1,56(sp)
    2438:	f84a                	sd	s2,48(sp)
    243a:	0880                	addi	s0,sp,80
    243c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    243e:	00004797          	auipc	a5,0x4
    2442:	a6278793          	addi	a5,a5,-1438 # 5ea0 <malloc+0x6b2>
    2446:	fcf43023          	sd	a5,-64(s0)
    244a:	00004797          	auipc	a5,0x4
    244e:	02678793          	addi	a5,a5,38 # 6470 <malloc+0xc82>
    2452:	fcf43423          	sd	a5,-56(s0)
    2456:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    245a:	00004517          	auipc	a0,0x4
    245e:	01e50513          	addi	a0,a0,30 # 6478 <malloc+0xc8a>
    2462:	00003097          	auipc	ra,0x3
    2466:	f96080e7          	jalr	-106(ra) # 53f8 <unlink>
  pid = fork();
    246a:	00003097          	auipc	ra,0x3
    246e:	f36080e7          	jalr	-202(ra) # 53a0 <fork>
  if(pid < 0) {
    2472:	04054663          	bltz	a0,24be <exectest+0x8e>
    2476:	84aa                	mv	s1,a0
  if(pid == 0) {
    2478:	e959                	bnez	a0,250e <exectest+0xde>
    close(1);
    247a:	4505                	li	a0,1
    247c:	00003097          	auipc	ra,0x3
    2480:	f54080e7          	jalr	-172(ra) # 53d0 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    2484:	20100593          	li	a1,513
    2488:	00004517          	auipc	a0,0x4
    248c:	ff050513          	addi	a0,a0,-16 # 6478 <malloc+0xc8a>
    2490:	00003097          	auipc	ra,0x3
    2494:	f58080e7          	jalr	-168(ra) # 53e8 <open>
    if(fd < 0) {
    2498:	04054163          	bltz	a0,24da <exectest+0xaa>
    if(fd != 1) {
    249c:	4785                	li	a5,1
    249e:	04f50c63          	beq	a0,a5,24f6 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    24a2:	85ca                	mv	a1,s2
    24a4:	00004517          	auipc	a0,0x4
    24a8:	fdc50513          	addi	a0,a0,-36 # 6480 <malloc+0xc92>
    24ac:	00003097          	auipc	ra,0x3
    24b0:	284080e7          	jalr	644(ra) # 5730 <printf>
      exit(1);
    24b4:	4505                	li	a0,1
    24b6:	00003097          	auipc	ra,0x3
    24ba:	ef2080e7          	jalr	-270(ra) # 53a8 <exit>
     printf("%s: fork failed\n", s);
    24be:	85ca                	mv	a1,s2
    24c0:	00004517          	auipc	a0,0x4
    24c4:	83050513          	addi	a0,a0,-2000 # 5cf0 <malloc+0x502>
    24c8:	00003097          	auipc	ra,0x3
    24cc:	268080e7          	jalr	616(ra) # 5730 <printf>
     exit(1);
    24d0:	4505                	li	a0,1
    24d2:	00003097          	auipc	ra,0x3
    24d6:	ed6080e7          	jalr	-298(ra) # 53a8 <exit>
      printf("%s: create failed\n", s);
    24da:	85ca                	mv	a1,s2
    24dc:	00004517          	auipc	a0,0x4
    24e0:	a2c50513          	addi	a0,a0,-1492 # 5f08 <malloc+0x71a>
    24e4:	00003097          	auipc	ra,0x3
    24e8:	24c080e7          	jalr	588(ra) # 5730 <printf>
      exit(1);
    24ec:	4505                	li	a0,1
    24ee:	00003097          	auipc	ra,0x3
    24f2:	eba080e7          	jalr	-326(ra) # 53a8 <exit>
    if(exec("echo", echoargv) < 0){
    24f6:	fc040593          	addi	a1,s0,-64
    24fa:	00004517          	auipc	a0,0x4
    24fe:	9a650513          	addi	a0,a0,-1626 # 5ea0 <malloc+0x6b2>
    2502:	00003097          	auipc	ra,0x3
    2506:	ede080e7          	jalr	-290(ra) # 53e0 <exec>
    250a:	02054163          	bltz	a0,252c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    250e:	fdc40513          	addi	a0,s0,-36
    2512:	00003097          	auipc	ra,0x3
    2516:	e9e080e7          	jalr	-354(ra) # 53b0 <wait>
    251a:	02951763          	bne	a0,s1,2548 <exectest+0x118>
  if(xstatus != 0)
    251e:	fdc42503          	lw	a0,-36(s0)
    2522:	cd0d                	beqz	a0,255c <exectest+0x12c>
    exit(xstatus);
    2524:	00003097          	auipc	ra,0x3
    2528:	e84080e7          	jalr	-380(ra) # 53a8 <exit>
      printf("%s: exec echo failed\n", s);
    252c:	85ca                	mv	a1,s2
    252e:	00004517          	auipc	a0,0x4
    2532:	f6250513          	addi	a0,a0,-158 # 6490 <malloc+0xca2>
    2536:	00003097          	auipc	ra,0x3
    253a:	1fa080e7          	jalr	506(ra) # 5730 <printf>
      exit(1);
    253e:	4505                	li	a0,1
    2540:	00003097          	auipc	ra,0x3
    2544:	e68080e7          	jalr	-408(ra) # 53a8 <exit>
    printf("%s: wait failed!\n", s);
    2548:	85ca                	mv	a1,s2
    254a:	00004517          	auipc	a0,0x4
    254e:	f5e50513          	addi	a0,a0,-162 # 64a8 <malloc+0xcba>
    2552:	00003097          	auipc	ra,0x3
    2556:	1de080e7          	jalr	478(ra) # 5730 <printf>
    255a:	b7d1                	j	251e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    255c:	4581                	li	a1,0
    255e:	00004517          	auipc	a0,0x4
    2562:	f1a50513          	addi	a0,a0,-230 # 6478 <malloc+0xc8a>
    2566:	00003097          	auipc	ra,0x3
    256a:	e82080e7          	jalr	-382(ra) # 53e8 <open>
  if(fd < 0) {
    256e:	02054a63          	bltz	a0,25a2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    2572:	4609                	li	a2,2
    2574:	fb840593          	addi	a1,s0,-72
    2578:	00003097          	auipc	ra,0x3
    257c:	e48080e7          	jalr	-440(ra) # 53c0 <read>
    2580:	4789                	li	a5,2
    2582:	02f50e63          	beq	a0,a5,25be <exectest+0x18e>
    printf("%s: read failed\n", s);
    2586:	85ca                	mv	a1,s2
    2588:	00004517          	auipc	a0,0x4
    258c:	cf050513          	addi	a0,a0,-784 # 6278 <malloc+0xa8a>
    2590:	00003097          	auipc	ra,0x3
    2594:	1a0080e7          	jalr	416(ra) # 5730 <printf>
    exit(1);
    2598:	4505                	li	a0,1
    259a:	00003097          	auipc	ra,0x3
    259e:	e0e080e7          	jalr	-498(ra) # 53a8 <exit>
    printf("%s: open failed\n", s);
    25a2:	85ca                	mv	a1,s2
    25a4:	00004517          	auipc	a0,0x4
    25a8:	f1c50513          	addi	a0,a0,-228 # 64c0 <malloc+0xcd2>
    25ac:	00003097          	auipc	ra,0x3
    25b0:	184080e7          	jalr	388(ra) # 5730 <printf>
    exit(1);
    25b4:	4505                	li	a0,1
    25b6:	00003097          	auipc	ra,0x3
    25ba:	df2080e7          	jalr	-526(ra) # 53a8 <exit>
  unlink("echo-ok");
    25be:	00004517          	auipc	a0,0x4
    25c2:	eba50513          	addi	a0,a0,-326 # 6478 <malloc+0xc8a>
    25c6:	00003097          	auipc	ra,0x3
    25ca:	e32080e7          	jalr	-462(ra) # 53f8 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    25ce:	fb844703          	lbu	a4,-72(s0)
    25d2:	04f00793          	li	a5,79
    25d6:	00f71863          	bne	a4,a5,25e6 <exectest+0x1b6>
    25da:	fb944703          	lbu	a4,-71(s0)
    25de:	04b00793          	li	a5,75
    25e2:	02f70063          	beq	a4,a5,2602 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    25e6:	85ca                	mv	a1,s2
    25e8:	00004517          	auipc	a0,0x4
    25ec:	ef050513          	addi	a0,a0,-272 # 64d8 <malloc+0xcea>
    25f0:	00003097          	auipc	ra,0x3
    25f4:	140080e7          	jalr	320(ra) # 5730 <printf>
    exit(1);
    25f8:	4505                	li	a0,1
    25fa:	00003097          	auipc	ra,0x3
    25fe:	dae080e7          	jalr	-594(ra) # 53a8 <exit>
    exit(0);
    2602:	4501                	li	a0,0
    2604:	00003097          	auipc	ra,0x3
    2608:	da4080e7          	jalr	-604(ra) # 53a8 <exit>

000000000000260c <bigargtest>:
{
    260c:	7179                	addi	sp,sp,-48
    260e:	f406                	sd	ra,40(sp)
    2610:	f022                	sd	s0,32(sp)
    2612:	ec26                	sd	s1,24(sp)
    2614:	1800                	addi	s0,sp,48
    2616:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2618:	00004517          	auipc	a0,0x4
    261c:	ed850513          	addi	a0,a0,-296 # 64f0 <malloc+0xd02>
    2620:	00003097          	auipc	ra,0x3
    2624:	dd8080e7          	jalr	-552(ra) # 53f8 <unlink>
  pid = fork();
    2628:	00003097          	auipc	ra,0x3
    262c:	d78080e7          	jalr	-648(ra) # 53a0 <fork>
  if(pid == 0){
    2630:	c121                	beqz	a0,2670 <bigargtest+0x64>
  } else if(pid < 0){
    2632:	0a054063          	bltz	a0,26d2 <bigargtest+0xc6>
  wait(&xstatus);
    2636:	fdc40513          	addi	a0,s0,-36
    263a:	00003097          	auipc	ra,0x3
    263e:	d76080e7          	jalr	-650(ra) # 53b0 <wait>
  if(xstatus != 0)
    2642:	fdc42503          	lw	a0,-36(s0)
    2646:	e545                	bnez	a0,26ee <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2648:	4581                	li	a1,0
    264a:	00004517          	auipc	a0,0x4
    264e:	ea650513          	addi	a0,a0,-346 # 64f0 <malloc+0xd02>
    2652:	00003097          	auipc	ra,0x3
    2656:	d96080e7          	jalr	-618(ra) # 53e8 <open>
  if(fd < 0){
    265a:	08054e63          	bltz	a0,26f6 <bigargtest+0xea>
  close(fd);
    265e:	00003097          	auipc	ra,0x3
    2662:	d72080e7          	jalr	-654(ra) # 53d0 <close>
}
    2666:	70a2                	ld	ra,40(sp)
    2668:	7402                	ld	s0,32(sp)
    266a:	64e2                	ld	s1,24(sp)
    266c:	6145                	addi	sp,sp,48
    266e:	8082                	ret
    2670:	00005797          	auipc	a5,0x5
    2674:	33078793          	addi	a5,a5,816 # 79a0 <args.1697>
    2678:	00005697          	auipc	a3,0x5
    267c:	42068693          	addi	a3,a3,1056 # 7a98 <args.1697+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2680:	00004717          	auipc	a4,0x4
    2684:	e8070713          	addi	a4,a4,-384 # 6500 <malloc+0xd12>
    2688:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    268a:	07a1                	addi	a5,a5,8
    268c:	fed79ee3          	bne	a5,a3,2688 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2690:	00005597          	auipc	a1,0x5
    2694:	31058593          	addi	a1,a1,784 # 79a0 <args.1697>
    2698:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    269c:	00004517          	auipc	a0,0x4
    26a0:	80450513          	addi	a0,a0,-2044 # 5ea0 <malloc+0x6b2>
    26a4:	00003097          	auipc	ra,0x3
    26a8:	d3c080e7          	jalr	-708(ra) # 53e0 <exec>
    fd = open("bigarg-ok", O_CREATE);
    26ac:	20000593          	li	a1,512
    26b0:	00004517          	auipc	a0,0x4
    26b4:	e4050513          	addi	a0,a0,-448 # 64f0 <malloc+0xd02>
    26b8:	00003097          	auipc	ra,0x3
    26bc:	d30080e7          	jalr	-720(ra) # 53e8 <open>
    close(fd);
    26c0:	00003097          	auipc	ra,0x3
    26c4:	d10080e7          	jalr	-752(ra) # 53d0 <close>
    exit(0);
    26c8:	4501                	li	a0,0
    26ca:	00003097          	auipc	ra,0x3
    26ce:	cde080e7          	jalr	-802(ra) # 53a8 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    26d2:	85a6                	mv	a1,s1
    26d4:	00004517          	auipc	a0,0x4
    26d8:	f0c50513          	addi	a0,a0,-244 # 65e0 <malloc+0xdf2>
    26dc:	00003097          	auipc	ra,0x3
    26e0:	054080e7          	jalr	84(ra) # 5730 <printf>
    exit(1);
    26e4:	4505                	li	a0,1
    26e6:	00003097          	auipc	ra,0x3
    26ea:	cc2080e7          	jalr	-830(ra) # 53a8 <exit>
    exit(xstatus);
    26ee:	00003097          	auipc	ra,0x3
    26f2:	cba080e7          	jalr	-838(ra) # 53a8 <exit>
    printf("%s: bigarg test failed!\n", s);
    26f6:	85a6                	mv	a1,s1
    26f8:	00004517          	auipc	a0,0x4
    26fc:	f0850513          	addi	a0,a0,-248 # 6600 <malloc+0xe12>
    2700:	00003097          	auipc	ra,0x3
    2704:	030080e7          	jalr	48(ra) # 5730 <printf>
    exit(1);
    2708:	4505                	li	a0,1
    270a:	00003097          	auipc	ra,0x3
    270e:	c9e080e7          	jalr	-866(ra) # 53a8 <exit>

0000000000002712 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    2712:	7139                	addi	sp,sp,-64
    2714:	fc06                	sd	ra,56(sp)
    2716:	f822                	sd	s0,48(sp)
    2718:	f426                	sd	s1,40(sp)
    271a:	f04a                	sd	s2,32(sp)
    271c:	ec4e                	sd	s3,24(sp)
    271e:	0080                	addi	s0,sp,64
    2720:	64b1                	lui	s1,0xc
    2722:	35048493          	addi	s1,s1,848 # c350 <buf+0x21a0>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    2726:	597d                	li	s2,-1
    2728:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    272c:	00003997          	auipc	s3,0x3
    2730:	77498993          	addi	s3,s3,1908 # 5ea0 <malloc+0x6b2>
    argv[0] = (char*)0xffffffff;
    2734:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    2738:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    273c:	fc040593          	addi	a1,s0,-64
    2740:	854e                	mv	a0,s3
    2742:	00003097          	auipc	ra,0x3
    2746:	c9e080e7          	jalr	-866(ra) # 53e0 <exec>
  for(int i = 0; i < 50000; i++){
    274a:	34fd                	addiw	s1,s1,-1
    274c:	f4e5                	bnez	s1,2734 <badarg+0x22>
  }
  
  exit(0);
    274e:	4501                	li	a0,0
    2750:	00003097          	auipc	ra,0x3
    2754:	c58080e7          	jalr	-936(ra) # 53a8 <exit>

0000000000002758 <pipe1>:
{
    2758:	711d                	addi	sp,sp,-96
    275a:	ec86                	sd	ra,88(sp)
    275c:	e8a2                	sd	s0,80(sp)
    275e:	e4a6                	sd	s1,72(sp)
    2760:	e0ca                	sd	s2,64(sp)
    2762:	fc4e                	sd	s3,56(sp)
    2764:	f852                	sd	s4,48(sp)
    2766:	f456                	sd	s5,40(sp)
    2768:	f05a                	sd	s6,32(sp)
    276a:	ec5e                	sd	s7,24(sp)
    276c:	1080                	addi	s0,sp,96
    276e:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    2770:	fa840513          	addi	a0,s0,-88
    2774:	00003097          	auipc	ra,0x3
    2778:	c44080e7          	jalr	-956(ra) # 53b8 <pipe>
    277c:	ed25                	bnez	a0,27f4 <pipe1+0x9c>
    277e:	84aa                	mv	s1,a0
  pid = fork();
    2780:	00003097          	auipc	ra,0x3
    2784:	c20080e7          	jalr	-992(ra) # 53a0 <fork>
    2788:	8a2a                	mv	s4,a0
  if(pid == 0){
    278a:	c159                	beqz	a0,2810 <pipe1+0xb8>
  } else if(pid > 0){
    278c:	16a05e63          	blez	a0,2908 <pipe1+0x1b0>
    close(fds[1]);
    2790:	fac42503          	lw	a0,-84(s0)
    2794:	00003097          	auipc	ra,0x3
    2798:	c3c080e7          	jalr	-964(ra) # 53d0 <close>
    total = 0;
    279c:	8a26                	mv	s4,s1
    cc = 1;
    279e:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    27a0:	00008a97          	auipc	s5,0x8
    27a4:	a10a8a93          	addi	s5,s5,-1520 # a1b0 <buf>
      if(cc > sizeof(buf))
    27a8:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    27aa:	864e                	mv	a2,s3
    27ac:	85d6                	mv	a1,s5
    27ae:	fa842503          	lw	a0,-88(s0)
    27b2:	00003097          	auipc	ra,0x3
    27b6:	c0e080e7          	jalr	-1010(ra) # 53c0 <read>
    27ba:	10a05263          	blez	a0,28be <pipe1+0x166>
      for(i = 0; i < n; i++){
    27be:	00008717          	auipc	a4,0x8
    27c2:	9f270713          	addi	a4,a4,-1550 # a1b0 <buf>
    27c6:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    27ca:	00074683          	lbu	a3,0(a4)
    27ce:	0ff4f793          	andi	a5,s1,255
    27d2:	2485                	addiw	s1,s1,1
    27d4:	0cf69163          	bne	a3,a5,2896 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    27d8:	0705                	addi	a4,a4,1
    27da:	fec498e3          	bne	s1,a2,27ca <pipe1+0x72>
      total += n;
    27de:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    27e2:	0019979b          	slliw	a5,s3,0x1
    27e6:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    27ea:	013b7363          	bgeu	s6,s3,27f0 <pipe1+0x98>
        cc = sizeof(buf);
    27ee:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    27f0:	84b2                	mv	s1,a2
    27f2:	bf65                	j	27aa <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    27f4:	85ca                	mv	a1,s2
    27f6:	00004517          	auipc	a0,0x4
    27fa:	e2a50513          	addi	a0,a0,-470 # 6620 <malloc+0xe32>
    27fe:	00003097          	auipc	ra,0x3
    2802:	f32080e7          	jalr	-206(ra) # 5730 <printf>
    exit(1);
    2806:	4505                	li	a0,1
    2808:	00003097          	auipc	ra,0x3
    280c:	ba0080e7          	jalr	-1120(ra) # 53a8 <exit>
    close(fds[0]);
    2810:	fa842503          	lw	a0,-88(s0)
    2814:	00003097          	auipc	ra,0x3
    2818:	bbc080e7          	jalr	-1092(ra) # 53d0 <close>
    for(n = 0; n < N; n++){
    281c:	00008b17          	auipc	s6,0x8
    2820:	994b0b13          	addi	s6,s6,-1644 # a1b0 <buf>
    2824:	416004bb          	negw	s1,s6
    2828:	0ff4f493          	andi	s1,s1,255
    282c:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    2830:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    2832:	6a85                	lui	s5,0x1
    2834:	42da8a93          	addi	s5,s5,1069 # 142d <exitwait+0xa7>
{
    2838:	87da                	mv	a5,s6
        buf[i] = seq++;
    283a:	0097873b          	addw	a4,a5,s1
    283e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    2842:	0785                	addi	a5,a5,1
    2844:	fef99be3          	bne	s3,a5,283a <pipe1+0xe2>
    2848:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    284c:	40900613          	li	a2,1033
    2850:	85de                	mv	a1,s7
    2852:	fac42503          	lw	a0,-84(s0)
    2856:	00003097          	auipc	ra,0x3
    285a:	b72080e7          	jalr	-1166(ra) # 53c8 <write>
    285e:	40900793          	li	a5,1033
    2862:	00f51c63          	bne	a0,a5,287a <pipe1+0x122>
    for(n = 0; n < N; n++){
    2866:	24a5                	addiw	s1,s1,9
    2868:	0ff4f493          	andi	s1,s1,255
    286c:	fd5a16e3          	bne	s4,s5,2838 <pipe1+0xe0>
    exit(0);
    2870:	4501                	li	a0,0
    2872:	00003097          	auipc	ra,0x3
    2876:	b36080e7          	jalr	-1226(ra) # 53a8 <exit>
        printf("%s: pipe1 oops 1\n", s);
    287a:	85ca                	mv	a1,s2
    287c:	00004517          	auipc	a0,0x4
    2880:	dbc50513          	addi	a0,a0,-580 # 6638 <malloc+0xe4a>
    2884:	00003097          	auipc	ra,0x3
    2888:	eac080e7          	jalr	-340(ra) # 5730 <printf>
        exit(1);
    288c:	4505                	li	a0,1
    288e:	00003097          	auipc	ra,0x3
    2892:	b1a080e7          	jalr	-1254(ra) # 53a8 <exit>
          printf("%s: pipe1 oops 2\n", s);
    2896:	85ca                	mv	a1,s2
    2898:	00004517          	auipc	a0,0x4
    289c:	db850513          	addi	a0,a0,-584 # 6650 <malloc+0xe62>
    28a0:	00003097          	auipc	ra,0x3
    28a4:	e90080e7          	jalr	-368(ra) # 5730 <printf>
}
    28a8:	60e6                	ld	ra,88(sp)
    28aa:	6446                	ld	s0,80(sp)
    28ac:	64a6                	ld	s1,72(sp)
    28ae:	6906                	ld	s2,64(sp)
    28b0:	79e2                	ld	s3,56(sp)
    28b2:	7a42                	ld	s4,48(sp)
    28b4:	7aa2                	ld	s5,40(sp)
    28b6:	7b02                	ld	s6,32(sp)
    28b8:	6be2                	ld	s7,24(sp)
    28ba:	6125                	addi	sp,sp,96
    28bc:	8082                	ret
    if(total != N * SZ){
    28be:	6785                	lui	a5,0x1
    28c0:	42d78793          	addi	a5,a5,1069 # 142d <exitwait+0xa7>
    28c4:	02fa0063          	beq	s4,a5,28e4 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    28c8:	85d2                	mv	a1,s4
    28ca:	00004517          	auipc	a0,0x4
    28ce:	d9e50513          	addi	a0,a0,-610 # 6668 <malloc+0xe7a>
    28d2:	00003097          	auipc	ra,0x3
    28d6:	e5e080e7          	jalr	-418(ra) # 5730 <printf>
      exit(1);
    28da:	4505                	li	a0,1
    28dc:	00003097          	auipc	ra,0x3
    28e0:	acc080e7          	jalr	-1332(ra) # 53a8 <exit>
    close(fds[0]);
    28e4:	fa842503          	lw	a0,-88(s0)
    28e8:	00003097          	auipc	ra,0x3
    28ec:	ae8080e7          	jalr	-1304(ra) # 53d0 <close>
    wait(&xstatus);
    28f0:	fa440513          	addi	a0,s0,-92
    28f4:	00003097          	auipc	ra,0x3
    28f8:	abc080e7          	jalr	-1348(ra) # 53b0 <wait>
    exit(xstatus);
    28fc:	fa442503          	lw	a0,-92(s0)
    2900:	00003097          	auipc	ra,0x3
    2904:	aa8080e7          	jalr	-1368(ra) # 53a8 <exit>
    printf("%s: fork() failed\n", s);
    2908:	85ca                	mv	a1,s2
    290a:	00004517          	auipc	a0,0x4
    290e:	d7e50513          	addi	a0,a0,-642 # 6688 <malloc+0xe9a>
    2912:	00003097          	auipc	ra,0x3
    2916:	e1e080e7          	jalr	-482(ra) # 5730 <printf>
    exit(1);
    291a:	4505                	li	a0,1
    291c:	00003097          	auipc	ra,0x3
    2920:	a8c080e7          	jalr	-1396(ra) # 53a8 <exit>

0000000000002924 <pgbug>:
{
    2924:	7179                	addi	sp,sp,-48
    2926:	f406                	sd	ra,40(sp)
    2928:	f022                	sd	s0,32(sp)
    292a:	ec26                	sd	s1,24(sp)
    292c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    292e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    2932:	00005497          	auipc	s1,0x5
    2936:	04e4b483          	ld	s1,78(s1) # 7980 <__SDATA_BEGIN__>
    293a:	fd840593          	addi	a1,s0,-40
    293e:	8526                	mv	a0,s1
    2940:	00003097          	auipc	ra,0x3
    2944:	aa0080e7          	jalr	-1376(ra) # 53e0 <exec>
  pipe((int*)0xeaeb0b5b00002f5e);
    2948:	8526                	mv	a0,s1
    294a:	00003097          	auipc	ra,0x3
    294e:	a6e080e7          	jalr	-1426(ra) # 53b8 <pipe>
  exit(0);
    2952:	4501                	li	a0,0
    2954:	00003097          	auipc	ra,0x3
    2958:	a54080e7          	jalr	-1452(ra) # 53a8 <exit>

000000000000295c <preempt>:
{
    295c:	7139                	addi	sp,sp,-64
    295e:	fc06                	sd	ra,56(sp)
    2960:	f822                	sd	s0,48(sp)
    2962:	f426                	sd	s1,40(sp)
    2964:	f04a                	sd	s2,32(sp)
    2966:	ec4e                	sd	s3,24(sp)
    2968:	e852                	sd	s4,16(sp)
    296a:	0080                	addi	s0,sp,64
    296c:	8a2a                	mv	s4,a0
  pid1 = fork();
    296e:	00003097          	auipc	ra,0x3
    2972:	a32080e7          	jalr	-1486(ra) # 53a0 <fork>
  if(pid1 < 0) {
    2976:	00054563          	bltz	a0,2980 <preempt+0x24>
    297a:	89aa                	mv	s3,a0
  if(pid1 == 0)
    297c:	ed19                	bnez	a0,299a <preempt+0x3e>
    for(;;)
    297e:	a001                	j	297e <preempt+0x22>
    printf("%s: fork failed");
    2980:	00003517          	auipc	a0,0x3
    2984:	3d850513          	addi	a0,a0,984 # 5d58 <malloc+0x56a>
    2988:	00003097          	auipc	ra,0x3
    298c:	da8080e7          	jalr	-600(ra) # 5730 <printf>
    exit(1);
    2990:	4505                	li	a0,1
    2992:	00003097          	auipc	ra,0x3
    2996:	a16080e7          	jalr	-1514(ra) # 53a8 <exit>
  pid2 = fork();
    299a:	00003097          	auipc	ra,0x3
    299e:	a06080e7          	jalr	-1530(ra) # 53a0 <fork>
    29a2:	892a                	mv	s2,a0
  if(pid2 < 0) {
    29a4:	00054463          	bltz	a0,29ac <preempt+0x50>
  if(pid2 == 0)
    29a8:	e105                	bnez	a0,29c8 <preempt+0x6c>
    for(;;)
    29aa:	a001                	j	29aa <preempt+0x4e>
    printf("%s: fork failed\n", s);
    29ac:	85d2                	mv	a1,s4
    29ae:	00003517          	auipc	a0,0x3
    29b2:	34250513          	addi	a0,a0,834 # 5cf0 <malloc+0x502>
    29b6:	00003097          	auipc	ra,0x3
    29ba:	d7a080e7          	jalr	-646(ra) # 5730 <printf>
    exit(1);
    29be:	4505                	li	a0,1
    29c0:	00003097          	auipc	ra,0x3
    29c4:	9e8080e7          	jalr	-1560(ra) # 53a8 <exit>
  pipe(pfds);
    29c8:	fc840513          	addi	a0,s0,-56
    29cc:	00003097          	auipc	ra,0x3
    29d0:	9ec080e7          	jalr	-1556(ra) # 53b8 <pipe>
  pid3 = fork();
    29d4:	00003097          	auipc	ra,0x3
    29d8:	9cc080e7          	jalr	-1588(ra) # 53a0 <fork>
    29dc:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    29de:	02054e63          	bltz	a0,2a1a <preempt+0xbe>
  if(pid3 == 0){
    29e2:	e13d                	bnez	a0,2a48 <preempt+0xec>
    close(pfds[0]);
    29e4:	fc842503          	lw	a0,-56(s0)
    29e8:	00003097          	auipc	ra,0x3
    29ec:	9e8080e7          	jalr	-1560(ra) # 53d0 <close>
    if(write(pfds[1], "x", 1) != 1)
    29f0:	4605                	li	a2,1
    29f2:	00004597          	auipc	a1,0x4
    29f6:	cae58593          	addi	a1,a1,-850 # 66a0 <malloc+0xeb2>
    29fa:	fcc42503          	lw	a0,-52(s0)
    29fe:	00003097          	auipc	ra,0x3
    2a02:	9ca080e7          	jalr	-1590(ra) # 53c8 <write>
    2a06:	4785                	li	a5,1
    2a08:	02f51763          	bne	a0,a5,2a36 <preempt+0xda>
    close(pfds[1]);
    2a0c:	fcc42503          	lw	a0,-52(s0)
    2a10:	00003097          	auipc	ra,0x3
    2a14:	9c0080e7          	jalr	-1600(ra) # 53d0 <close>
    for(;;)
    2a18:	a001                	j	2a18 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    2a1a:	85d2                	mv	a1,s4
    2a1c:	00003517          	auipc	a0,0x3
    2a20:	2d450513          	addi	a0,a0,724 # 5cf0 <malloc+0x502>
    2a24:	00003097          	auipc	ra,0x3
    2a28:	d0c080e7          	jalr	-756(ra) # 5730 <printf>
     exit(1);
    2a2c:	4505                	li	a0,1
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	97a080e7          	jalr	-1670(ra) # 53a8 <exit>
      printf("%s: preempt write error");
    2a36:	00004517          	auipc	a0,0x4
    2a3a:	c7250513          	addi	a0,a0,-910 # 66a8 <malloc+0xeba>
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	cf2080e7          	jalr	-782(ra) # 5730 <printf>
    2a46:	b7d9                	j	2a0c <preempt+0xb0>
  close(pfds[1]);
    2a48:	fcc42503          	lw	a0,-52(s0)
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	984080e7          	jalr	-1660(ra) # 53d0 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    2a54:	660d                	lui	a2,0x3
    2a56:	00007597          	auipc	a1,0x7
    2a5a:	75a58593          	addi	a1,a1,1882 # a1b0 <buf>
    2a5e:	fc842503          	lw	a0,-56(s0)
    2a62:	00003097          	auipc	ra,0x3
    2a66:	95e080e7          	jalr	-1698(ra) # 53c0 <read>
    2a6a:	4785                	li	a5,1
    2a6c:	02f50263          	beq	a0,a5,2a90 <preempt+0x134>
    printf("%s: preempt read error");
    2a70:	00004517          	auipc	a0,0x4
    2a74:	c5050513          	addi	a0,a0,-944 # 66c0 <malloc+0xed2>
    2a78:	00003097          	auipc	ra,0x3
    2a7c:	cb8080e7          	jalr	-840(ra) # 5730 <printf>
}
    2a80:	70e2                	ld	ra,56(sp)
    2a82:	7442                	ld	s0,48(sp)
    2a84:	74a2                	ld	s1,40(sp)
    2a86:	7902                	ld	s2,32(sp)
    2a88:	69e2                	ld	s3,24(sp)
    2a8a:	6a42                	ld	s4,16(sp)
    2a8c:	6121                	addi	sp,sp,64
    2a8e:	8082                	ret
  close(pfds[0]);
    2a90:	fc842503          	lw	a0,-56(s0)
    2a94:	00003097          	auipc	ra,0x3
    2a98:	93c080e7          	jalr	-1732(ra) # 53d0 <close>
  printf("kill... ");
    2a9c:	00004517          	auipc	a0,0x4
    2aa0:	c3c50513          	addi	a0,a0,-964 # 66d8 <malloc+0xeea>
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	c8c080e7          	jalr	-884(ra) # 5730 <printf>
  kill(pid1);
    2aac:	854e                	mv	a0,s3
    2aae:	00003097          	auipc	ra,0x3
    2ab2:	92a080e7          	jalr	-1750(ra) # 53d8 <kill>
  kill(pid2);
    2ab6:	854a                	mv	a0,s2
    2ab8:	00003097          	auipc	ra,0x3
    2abc:	920080e7          	jalr	-1760(ra) # 53d8 <kill>
  kill(pid3);
    2ac0:	8526                	mv	a0,s1
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	916080e7          	jalr	-1770(ra) # 53d8 <kill>
  printf("wait... ");
    2aca:	00004517          	auipc	a0,0x4
    2ace:	c1e50513          	addi	a0,a0,-994 # 66e8 <malloc+0xefa>
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	c5e080e7          	jalr	-930(ra) # 5730 <printf>
  wait(0);
    2ada:	4501                	li	a0,0
    2adc:	00003097          	auipc	ra,0x3
    2ae0:	8d4080e7          	jalr	-1836(ra) # 53b0 <wait>
  wait(0);
    2ae4:	4501                	li	a0,0
    2ae6:	00003097          	auipc	ra,0x3
    2aea:	8ca080e7          	jalr	-1846(ra) # 53b0 <wait>
  wait(0);
    2aee:	4501                	li	a0,0
    2af0:	00003097          	auipc	ra,0x3
    2af4:	8c0080e7          	jalr	-1856(ra) # 53b0 <wait>
    2af8:	b761                	j	2a80 <preempt+0x124>

0000000000002afa <reparent>:
{
    2afa:	7179                	addi	sp,sp,-48
    2afc:	f406                	sd	ra,40(sp)
    2afe:	f022                	sd	s0,32(sp)
    2b00:	ec26                	sd	s1,24(sp)
    2b02:	e84a                	sd	s2,16(sp)
    2b04:	e44e                	sd	s3,8(sp)
    2b06:	e052                	sd	s4,0(sp)
    2b08:	1800                	addi	s0,sp,48
    2b0a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	91c080e7          	jalr	-1764(ra) # 5428 <getpid>
    2b14:	8a2a                	mv	s4,a0
    2b16:	0c800913          	li	s2,200
    int pid = fork();
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	886080e7          	jalr	-1914(ra) # 53a0 <fork>
    2b22:	84aa                	mv	s1,a0
    if(pid < 0){
    2b24:	02054263          	bltz	a0,2b48 <reparent+0x4e>
    if(pid){
    2b28:	cd21                	beqz	a0,2b80 <reparent+0x86>
      if(wait(0) != pid){
    2b2a:	4501                	li	a0,0
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	884080e7          	jalr	-1916(ra) # 53b0 <wait>
    2b34:	02951863          	bne	a0,s1,2b64 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    2b38:	397d                	addiw	s2,s2,-1
    2b3a:	fe0910e3          	bnez	s2,2b1a <reparent+0x20>
  exit(0);
    2b3e:	4501                	li	a0,0
    2b40:	00003097          	auipc	ra,0x3
    2b44:	868080e7          	jalr	-1944(ra) # 53a8 <exit>
      printf("%s: fork failed\n", s);
    2b48:	85ce                	mv	a1,s3
    2b4a:	00003517          	auipc	a0,0x3
    2b4e:	1a650513          	addi	a0,a0,422 # 5cf0 <malloc+0x502>
    2b52:	00003097          	auipc	ra,0x3
    2b56:	bde080e7          	jalr	-1058(ra) # 5730 <printf>
      exit(1);
    2b5a:	4505                	li	a0,1
    2b5c:	00003097          	auipc	ra,0x3
    2b60:	84c080e7          	jalr	-1972(ra) # 53a8 <exit>
        printf("%s: wait wrong pid\n", s);
    2b64:	85ce                	mv	a1,s3
    2b66:	00003517          	auipc	a0,0x3
    2b6a:	1ba50513          	addi	a0,a0,442 # 5d20 <malloc+0x532>
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	bc2080e7          	jalr	-1086(ra) # 5730 <printf>
        exit(1);
    2b76:	4505                	li	a0,1
    2b78:	00003097          	auipc	ra,0x3
    2b7c:	830080e7          	jalr	-2000(ra) # 53a8 <exit>
      int pid2 = fork();
    2b80:	00003097          	auipc	ra,0x3
    2b84:	820080e7          	jalr	-2016(ra) # 53a0 <fork>
      if(pid2 < 0){
    2b88:	00054763          	bltz	a0,2b96 <reparent+0x9c>
      exit(0);
    2b8c:	4501                	li	a0,0
    2b8e:	00003097          	auipc	ra,0x3
    2b92:	81a080e7          	jalr	-2022(ra) # 53a8 <exit>
        kill(master_pid);
    2b96:	8552                	mv	a0,s4
    2b98:	00003097          	auipc	ra,0x3
    2b9c:	840080e7          	jalr	-1984(ra) # 53d8 <kill>
        exit(1);
    2ba0:	4505                	li	a0,1
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	806080e7          	jalr	-2042(ra) # 53a8 <exit>

0000000000002baa <mem>:
{
    2baa:	7139                	addi	sp,sp,-64
    2bac:	fc06                	sd	ra,56(sp)
    2bae:	f822                	sd	s0,48(sp)
    2bb0:	f426                	sd	s1,40(sp)
    2bb2:	f04a                	sd	s2,32(sp)
    2bb4:	ec4e                	sd	s3,24(sp)
    2bb6:	0080                	addi	s0,sp,64
    2bb8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    2bba:	00002097          	auipc	ra,0x2
    2bbe:	7e6080e7          	jalr	2022(ra) # 53a0 <fork>
    m1 = 0;
    2bc2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    2bc4:	6909                	lui	s2,0x2
    2bc6:	71190913          	addi	s2,s2,1809 # 2711 <bigargtest+0x105>
  if((pid = fork()) == 0){
    2bca:	ed39                	bnez	a0,2c28 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    2bcc:	854a                	mv	a0,s2
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	c20080e7          	jalr	-992(ra) # 57ee <malloc>
    2bd6:	c501                	beqz	a0,2bde <mem+0x34>
      *(char**)m2 = m1;
    2bd8:	e104                	sd	s1,0(a0)
      m1 = m2;
    2bda:	84aa                	mv	s1,a0
    2bdc:	bfc5                	j	2bcc <mem+0x22>
    while(m1){
    2bde:	c881                	beqz	s1,2bee <mem+0x44>
      m2 = *(char**)m1;
    2be0:	8526                	mv	a0,s1
    2be2:	6084                	ld	s1,0(s1)
      free(m1);
    2be4:	00003097          	auipc	ra,0x3
    2be8:	b82080e7          	jalr	-1150(ra) # 5766 <free>
    while(m1){
    2bec:	f8f5                	bnez	s1,2be0 <mem+0x36>
    m1 = malloc(1024*20);
    2bee:	6515                	lui	a0,0x5
    2bf0:	00003097          	auipc	ra,0x3
    2bf4:	bfe080e7          	jalr	-1026(ra) # 57ee <malloc>
    if(m1 == 0){
    2bf8:	c911                	beqz	a0,2c0c <mem+0x62>
    free(m1);
    2bfa:	00003097          	auipc	ra,0x3
    2bfe:	b6c080e7          	jalr	-1172(ra) # 5766 <free>
    exit(0);
    2c02:	4501                	li	a0,0
    2c04:	00002097          	auipc	ra,0x2
    2c08:	7a4080e7          	jalr	1956(ra) # 53a8 <exit>
      printf("couldn't allocate mem?!!\n", s);
    2c0c:	85ce                	mv	a1,s3
    2c0e:	00004517          	auipc	a0,0x4
    2c12:	aea50513          	addi	a0,a0,-1302 # 66f8 <malloc+0xf0a>
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	b1a080e7          	jalr	-1254(ra) # 5730 <printf>
      exit(1);
    2c1e:	4505                	li	a0,1
    2c20:	00002097          	auipc	ra,0x2
    2c24:	788080e7          	jalr	1928(ra) # 53a8 <exit>
    wait(&xstatus);
    2c28:	fcc40513          	addi	a0,s0,-52
    2c2c:	00002097          	auipc	ra,0x2
    2c30:	784080e7          	jalr	1924(ra) # 53b0 <wait>
    exit(xstatus);
    2c34:	fcc42503          	lw	a0,-52(s0)
    2c38:	00002097          	auipc	ra,0x2
    2c3c:	770080e7          	jalr	1904(ra) # 53a8 <exit>

0000000000002c40 <sharedfd>:
{
    2c40:	7159                	addi	sp,sp,-112
    2c42:	f486                	sd	ra,104(sp)
    2c44:	f0a2                	sd	s0,96(sp)
    2c46:	eca6                	sd	s1,88(sp)
    2c48:	e8ca                	sd	s2,80(sp)
    2c4a:	e4ce                	sd	s3,72(sp)
    2c4c:	e0d2                	sd	s4,64(sp)
    2c4e:	fc56                	sd	s5,56(sp)
    2c50:	f85a                	sd	s6,48(sp)
    2c52:	f45e                	sd	s7,40(sp)
    2c54:	1880                	addi	s0,sp,112
    2c56:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    2c58:	00003517          	auipc	a0,0x3
    2c5c:	d8850513          	addi	a0,a0,-632 # 59e0 <malloc+0x1f2>
    2c60:	00002097          	auipc	ra,0x2
    2c64:	798080e7          	jalr	1944(ra) # 53f8 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    2c68:	20200593          	li	a1,514
    2c6c:	00003517          	auipc	a0,0x3
    2c70:	d7450513          	addi	a0,a0,-652 # 59e0 <malloc+0x1f2>
    2c74:	00002097          	auipc	ra,0x2
    2c78:	774080e7          	jalr	1908(ra) # 53e8 <open>
  if(fd < 0){
    2c7c:	04054a63          	bltz	a0,2cd0 <sharedfd+0x90>
    2c80:	892a                	mv	s2,a0
  pid = fork();
    2c82:	00002097          	auipc	ra,0x2
    2c86:	71e080e7          	jalr	1822(ra) # 53a0 <fork>
    2c8a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2c8c:	06300593          	li	a1,99
    2c90:	c119                	beqz	a0,2c96 <sharedfd+0x56>
    2c92:	07000593          	li	a1,112
    2c96:	4629                	li	a2,10
    2c98:	fa040513          	addi	a0,s0,-96
    2c9c:	00002097          	auipc	ra,0x2
    2ca0:	588080e7          	jalr	1416(ra) # 5224 <memset>
    2ca4:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    2ca8:	4629                	li	a2,10
    2caa:	fa040593          	addi	a1,s0,-96
    2cae:	854a                	mv	a0,s2
    2cb0:	00002097          	auipc	ra,0x2
    2cb4:	718080e7          	jalr	1816(ra) # 53c8 <write>
    2cb8:	47a9                	li	a5,10
    2cba:	02f51963          	bne	a0,a5,2cec <sharedfd+0xac>
  for(i = 0; i < N; i++){
    2cbe:	34fd                	addiw	s1,s1,-1
    2cc0:	f4e5                	bnez	s1,2ca8 <sharedfd+0x68>
  if(pid == 0) {
    2cc2:	04099363          	bnez	s3,2d08 <sharedfd+0xc8>
    exit(0);
    2cc6:	4501                	li	a0,0
    2cc8:	00002097          	auipc	ra,0x2
    2ccc:	6e0080e7          	jalr	1760(ra) # 53a8 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    2cd0:	85d2                	mv	a1,s4
    2cd2:	00004517          	auipc	a0,0x4
    2cd6:	a4650513          	addi	a0,a0,-1466 # 6718 <malloc+0xf2a>
    2cda:	00003097          	auipc	ra,0x3
    2cde:	a56080e7          	jalr	-1450(ra) # 5730 <printf>
    exit(1);
    2ce2:	4505                	li	a0,1
    2ce4:	00002097          	auipc	ra,0x2
    2ce8:	6c4080e7          	jalr	1732(ra) # 53a8 <exit>
      printf("%s: write sharedfd failed\n", s);
    2cec:	85d2                	mv	a1,s4
    2cee:	00004517          	auipc	a0,0x4
    2cf2:	a5250513          	addi	a0,a0,-1454 # 6740 <malloc+0xf52>
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	a3a080e7          	jalr	-1478(ra) # 5730 <printf>
      exit(1);
    2cfe:	4505                	li	a0,1
    2d00:	00002097          	auipc	ra,0x2
    2d04:	6a8080e7          	jalr	1704(ra) # 53a8 <exit>
    wait(&xstatus);
    2d08:	f9c40513          	addi	a0,s0,-100
    2d0c:	00002097          	auipc	ra,0x2
    2d10:	6a4080e7          	jalr	1700(ra) # 53b0 <wait>
    if(xstatus != 0)
    2d14:	f9c42983          	lw	s3,-100(s0)
    2d18:	00098763          	beqz	s3,2d26 <sharedfd+0xe6>
      exit(xstatus);
    2d1c:	854e                	mv	a0,s3
    2d1e:	00002097          	auipc	ra,0x2
    2d22:	68a080e7          	jalr	1674(ra) # 53a8 <exit>
  close(fd);
    2d26:	854a                	mv	a0,s2
    2d28:	00002097          	auipc	ra,0x2
    2d2c:	6a8080e7          	jalr	1704(ra) # 53d0 <close>
  fd = open("sharedfd", 0);
    2d30:	4581                	li	a1,0
    2d32:	00003517          	auipc	a0,0x3
    2d36:	cae50513          	addi	a0,a0,-850 # 59e0 <malloc+0x1f2>
    2d3a:	00002097          	auipc	ra,0x2
    2d3e:	6ae080e7          	jalr	1710(ra) # 53e8 <open>
    2d42:	8baa                	mv	s7,a0
  nc = np = 0;
    2d44:	8ace                	mv	s5,s3
  if(fd < 0){
    2d46:	02054563          	bltz	a0,2d70 <sharedfd+0x130>
    2d4a:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    2d4e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    2d52:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    2d56:	4629                	li	a2,10
    2d58:	fa040593          	addi	a1,s0,-96
    2d5c:	855e                	mv	a0,s7
    2d5e:	00002097          	auipc	ra,0x2
    2d62:	662080e7          	jalr	1634(ra) # 53c0 <read>
    2d66:	02a05f63          	blez	a0,2da4 <sharedfd+0x164>
    2d6a:	fa040793          	addi	a5,s0,-96
    2d6e:	a01d                	j	2d94 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    2d70:	85d2                	mv	a1,s4
    2d72:	00004517          	auipc	a0,0x4
    2d76:	9ee50513          	addi	a0,a0,-1554 # 6760 <malloc+0xf72>
    2d7a:	00003097          	auipc	ra,0x3
    2d7e:	9b6080e7          	jalr	-1610(ra) # 5730 <printf>
    exit(1);
    2d82:	4505                	li	a0,1
    2d84:	00002097          	auipc	ra,0x2
    2d88:	624080e7          	jalr	1572(ra) # 53a8 <exit>
        nc++;
    2d8c:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    2d8e:	0785                	addi	a5,a5,1
    2d90:	fd2783e3          	beq	a5,s2,2d56 <sharedfd+0x116>
      if(buf[i] == 'c')
    2d94:	0007c703          	lbu	a4,0(a5)
    2d98:	fe970ae3          	beq	a4,s1,2d8c <sharedfd+0x14c>
      if(buf[i] == 'p')
    2d9c:	ff6719e3          	bne	a4,s6,2d8e <sharedfd+0x14e>
        np++;
    2da0:	2a85                	addiw	s5,s5,1
    2da2:	b7f5                	j	2d8e <sharedfd+0x14e>
  close(fd);
    2da4:	855e                	mv	a0,s7
    2da6:	00002097          	auipc	ra,0x2
    2daa:	62a080e7          	jalr	1578(ra) # 53d0 <close>
  unlink("sharedfd");
    2dae:	00003517          	auipc	a0,0x3
    2db2:	c3250513          	addi	a0,a0,-974 # 59e0 <malloc+0x1f2>
    2db6:	00002097          	auipc	ra,0x2
    2dba:	642080e7          	jalr	1602(ra) # 53f8 <unlink>
  if(nc == N*SZ && np == N*SZ){
    2dbe:	6789                	lui	a5,0x2
    2dc0:	71078793          	addi	a5,a5,1808 # 2710 <bigargtest+0x104>
    2dc4:	00f99763          	bne	s3,a5,2dd2 <sharedfd+0x192>
    2dc8:	6789                	lui	a5,0x2
    2dca:	71078793          	addi	a5,a5,1808 # 2710 <bigargtest+0x104>
    2dce:	02fa8063          	beq	s5,a5,2dee <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    2dd2:	85d2                	mv	a1,s4
    2dd4:	00004517          	auipc	a0,0x4
    2dd8:	9b450513          	addi	a0,a0,-1612 # 6788 <malloc+0xf9a>
    2ddc:	00003097          	auipc	ra,0x3
    2de0:	954080e7          	jalr	-1708(ra) # 5730 <printf>
    exit(1);
    2de4:	4505                	li	a0,1
    2de6:	00002097          	auipc	ra,0x2
    2dea:	5c2080e7          	jalr	1474(ra) # 53a8 <exit>
    exit(0);
    2dee:	4501                	li	a0,0
    2df0:	00002097          	auipc	ra,0x2
    2df4:	5b8080e7          	jalr	1464(ra) # 53a8 <exit>

0000000000002df8 <fourfiles>:
{
    2df8:	7171                	addi	sp,sp,-176
    2dfa:	f506                	sd	ra,168(sp)
    2dfc:	f122                	sd	s0,160(sp)
    2dfe:	ed26                	sd	s1,152(sp)
    2e00:	e94a                	sd	s2,144(sp)
    2e02:	e54e                	sd	s3,136(sp)
    2e04:	e152                	sd	s4,128(sp)
    2e06:	fcd6                	sd	s5,120(sp)
    2e08:	f8da                	sd	s6,112(sp)
    2e0a:	f4de                	sd	s7,104(sp)
    2e0c:	f0e2                	sd	s8,96(sp)
    2e0e:	ece6                	sd	s9,88(sp)
    2e10:	e8ea                	sd	s10,80(sp)
    2e12:	e4ee                	sd	s11,72(sp)
    2e14:	1900                	addi	s0,sp,176
    2e16:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    2e18:	00003797          	auipc	a5,0x3
    2e1c:	ac078793          	addi	a5,a5,-1344 # 58d8 <malloc+0xea>
    2e20:	f6f43823          	sd	a5,-144(s0)
    2e24:	00003797          	auipc	a5,0x3
    2e28:	abc78793          	addi	a5,a5,-1348 # 58e0 <malloc+0xf2>
    2e2c:	f6f43c23          	sd	a5,-136(s0)
    2e30:	00003797          	auipc	a5,0x3
    2e34:	ab878793          	addi	a5,a5,-1352 # 58e8 <malloc+0xfa>
    2e38:	f8f43023          	sd	a5,-128(s0)
    2e3c:	00003797          	auipc	a5,0x3
    2e40:	ab478793          	addi	a5,a5,-1356 # 58f0 <malloc+0x102>
    2e44:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    2e48:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    2e4c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    2e4e:	4481                	li	s1,0
    2e50:	4a11                	li	s4,4
    fname = names[pi];
    2e52:	00093983          	ld	s3,0(s2)
    unlink(fname);
    2e56:	854e                	mv	a0,s3
    2e58:	00002097          	auipc	ra,0x2
    2e5c:	5a0080e7          	jalr	1440(ra) # 53f8 <unlink>
    pid = fork();
    2e60:	00002097          	auipc	ra,0x2
    2e64:	540080e7          	jalr	1344(ra) # 53a0 <fork>
    if(pid < 0){
    2e68:	04054563          	bltz	a0,2eb2 <fourfiles+0xba>
    if(pid == 0){
    2e6c:	c12d                	beqz	a0,2ece <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    2e6e:	2485                	addiw	s1,s1,1
    2e70:	0921                	addi	s2,s2,8
    2e72:	ff4490e3          	bne	s1,s4,2e52 <fourfiles+0x5a>
    2e76:	4491                	li	s1,4
    wait(&xstatus);
    2e78:	f6c40513          	addi	a0,s0,-148
    2e7c:	00002097          	auipc	ra,0x2
    2e80:	534080e7          	jalr	1332(ra) # 53b0 <wait>
    if(xstatus != 0)
    2e84:	f6c42503          	lw	a0,-148(s0)
    2e88:	ed69                	bnez	a0,2f62 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    2e8a:	34fd                	addiw	s1,s1,-1
    2e8c:	f4f5                	bnez	s1,2e78 <fourfiles+0x80>
    2e8e:	03000b13          	li	s6,48
    total = 0;
    2e92:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2e96:	00007a17          	auipc	s4,0x7
    2e9a:	31aa0a13          	addi	s4,s4,794 # a1b0 <buf>
    2e9e:	00007a97          	auipc	s5,0x7
    2ea2:	313a8a93          	addi	s5,s5,787 # a1b1 <buf+0x1>
    if(total != N*SZ){
    2ea6:	6d05                	lui	s10,0x1
    2ea8:	770d0d13          	addi	s10,s10,1904 # 1770 <kernmem+0x8a>
  for(i = 0; i < NCHILD; i++){
    2eac:	03400d93          	li	s11,52
    2eb0:	a23d                	j	2fde <fourfiles+0x1e6>
      printf("fork failed\n", s);
    2eb2:	85e6                	mv	a1,s9
    2eb4:	00003517          	auipc	a0,0x3
    2eb8:	73c50513          	addi	a0,a0,1852 # 65f0 <malloc+0xe02>
    2ebc:	00003097          	auipc	ra,0x3
    2ec0:	874080e7          	jalr	-1932(ra) # 5730 <printf>
      exit(1);
    2ec4:	4505                	li	a0,1
    2ec6:	00002097          	auipc	ra,0x2
    2eca:	4e2080e7          	jalr	1250(ra) # 53a8 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    2ece:	20200593          	li	a1,514
    2ed2:	854e                	mv	a0,s3
    2ed4:	00002097          	auipc	ra,0x2
    2ed8:	514080e7          	jalr	1300(ra) # 53e8 <open>
    2edc:	892a                	mv	s2,a0
      if(fd < 0){
    2ede:	04054763          	bltz	a0,2f2c <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    2ee2:	1f400613          	li	a2,500
    2ee6:	0304859b          	addiw	a1,s1,48
    2eea:	00007517          	auipc	a0,0x7
    2eee:	2c650513          	addi	a0,a0,710 # a1b0 <buf>
    2ef2:	00002097          	auipc	ra,0x2
    2ef6:	332080e7          	jalr	818(ra) # 5224 <memset>
    2efa:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    2efc:	00007997          	auipc	s3,0x7
    2f00:	2b498993          	addi	s3,s3,692 # a1b0 <buf>
    2f04:	1f400613          	li	a2,500
    2f08:	85ce                	mv	a1,s3
    2f0a:	854a                	mv	a0,s2
    2f0c:	00002097          	auipc	ra,0x2
    2f10:	4bc080e7          	jalr	1212(ra) # 53c8 <write>
    2f14:	85aa                	mv	a1,a0
    2f16:	1f400793          	li	a5,500
    2f1a:	02f51763          	bne	a0,a5,2f48 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    2f1e:	34fd                	addiw	s1,s1,-1
    2f20:	f0f5                	bnez	s1,2f04 <fourfiles+0x10c>
      exit(0);
    2f22:	4501                	li	a0,0
    2f24:	00002097          	auipc	ra,0x2
    2f28:	484080e7          	jalr	1156(ra) # 53a8 <exit>
        printf("create failed\n", s);
    2f2c:	85e6                	mv	a1,s9
    2f2e:	00004517          	auipc	a0,0x4
    2f32:	87250513          	addi	a0,a0,-1934 # 67a0 <malloc+0xfb2>
    2f36:	00002097          	auipc	ra,0x2
    2f3a:	7fa080e7          	jalr	2042(ra) # 5730 <printf>
        exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	00002097          	auipc	ra,0x2
    2f44:	468080e7          	jalr	1128(ra) # 53a8 <exit>
          printf("write failed %d\n", n);
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	86850513          	addi	a0,a0,-1944 # 67b0 <malloc+0xfc2>
    2f50:	00002097          	auipc	ra,0x2
    2f54:	7e0080e7          	jalr	2016(ra) # 5730 <printf>
          exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	00002097          	auipc	ra,0x2
    2f5e:	44e080e7          	jalr	1102(ra) # 53a8 <exit>
      exit(xstatus);
    2f62:	00002097          	auipc	ra,0x2
    2f66:	446080e7          	jalr	1094(ra) # 53a8 <exit>
          printf("wrong char\n", s);
    2f6a:	85e6                	mv	a1,s9
    2f6c:	00004517          	auipc	a0,0x4
    2f70:	85c50513          	addi	a0,a0,-1956 # 67c8 <malloc+0xfda>
    2f74:	00002097          	auipc	ra,0x2
    2f78:	7bc080e7          	jalr	1980(ra) # 5730 <printf>
          exit(1);
    2f7c:	4505                	li	a0,1
    2f7e:	00002097          	auipc	ra,0x2
    2f82:	42a080e7          	jalr	1066(ra) # 53a8 <exit>
      total += n;
    2f86:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2f8a:	660d                	lui	a2,0x3
    2f8c:	85d2                	mv	a1,s4
    2f8e:	854e                	mv	a0,s3
    2f90:	00002097          	auipc	ra,0x2
    2f94:	430080e7          	jalr	1072(ra) # 53c0 <read>
    2f98:	02a05363          	blez	a0,2fbe <fourfiles+0x1c6>
    2f9c:	00007797          	auipc	a5,0x7
    2fa0:	21478793          	addi	a5,a5,532 # a1b0 <buf>
    2fa4:	fff5069b          	addiw	a3,a0,-1
    2fa8:	1682                	slli	a3,a3,0x20
    2faa:	9281                	srli	a3,a3,0x20
    2fac:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    2fae:	0007c703          	lbu	a4,0(a5)
    2fb2:	fa971ce3          	bne	a4,s1,2f6a <fourfiles+0x172>
      for(j = 0; j < n; j++){
    2fb6:	0785                	addi	a5,a5,1
    2fb8:	fed79be3          	bne	a5,a3,2fae <fourfiles+0x1b6>
    2fbc:	b7e9                	j	2f86 <fourfiles+0x18e>
    close(fd);
    2fbe:	854e                	mv	a0,s3
    2fc0:	00002097          	auipc	ra,0x2
    2fc4:	410080e7          	jalr	1040(ra) # 53d0 <close>
    if(total != N*SZ){
    2fc8:	03a91963          	bne	s2,s10,2ffa <fourfiles+0x202>
    unlink(fname);
    2fcc:	8562                	mv	a0,s8
    2fce:	00002097          	auipc	ra,0x2
    2fd2:	42a080e7          	jalr	1066(ra) # 53f8 <unlink>
  for(i = 0; i < NCHILD; i++){
    2fd6:	0ba1                	addi	s7,s7,8
    2fd8:	2b05                	addiw	s6,s6,1
    2fda:	03bb0e63          	beq	s6,s11,3016 <fourfiles+0x21e>
    fname = names[i];
    2fde:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    2fe2:	4581                	li	a1,0
    2fe4:	8562                	mv	a0,s8
    2fe6:	00002097          	auipc	ra,0x2
    2fea:	402080e7          	jalr	1026(ra) # 53e8 <open>
    2fee:	89aa                	mv	s3,a0
    total = 0;
    2ff0:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    2ff4:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    2ff8:	bf49                	j	2f8a <fourfiles+0x192>
      printf("wrong length %d\n", total);
    2ffa:	85ca                	mv	a1,s2
    2ffc:	00003517          	auipc	a0,0x3
    3000:	7dc50513          	addi	a0,a0,2012 # 67d8 <malloc+0xfea>
    3004:	00002097          	auipc	ra,0x2
    3008:	72c080e7          	jalr	1836(ra) # 5730 <printf>
      exit(1);
    300c:	4505                	li	a0,1
    300e:	00002097          	auipc	ra,0x2
    3012:	39a080e7          	jalr	922(ra) # 53a8 <exit>
}
    3016:	70aa                	ld	ra,168(sp)
    3018:	740a                	ld	s0,160(sp)
    301a:	64ea                	ld	s1,152(sp)
    301c:	694a                	ld	s2,144(sp)
    301e:	69aa                	ld	s3,136(sp)
    3020:	6a0a                	ld	s4,128(sp)
    3022:	7ae6                	ld	s5,120(sp)
    3024:	7b46                	ld	s6,112(sp)
    3026:	7ba6                	ld	s7,104(sp)
    3028:	7c06                	ld	s8,96(sp)
    302a:	6ce6                	ld	s9,88(sp)
    302c:	6d46                	ld	s10,80(sp)
    302e:	6da6                	ld	s11,72(sp)
    3030:	614d                	addi	sp,sp,176
    3032:	8082                	ret

0000000000003034 <bigfile>:
{
    3034:	7139                	addi	sp,sp,-64
    3036:	fc06                	sd	ra,56(sp)
    3038:	f822                	sd	s0,48(sp)
    303a:	f426                	sd	s1,40(sp)
    303c:	f04a                	sd	s2,32(sp)
    303e:	ec4e                	sd	s3,24(sp)
    3040:	e852                	sd	s4,16(sp)
    3042:	e456                	sd	s5,8(sp)
    3044:	0080                	addi	s0,sp,64
    3046:	8aaa                	mv	s5,a0
  unlink("bigfile");
    3048:	00003517          	auipc	a0,0x3
    304c:	ae850513          	addi	a0,a0,-1304 # 5b30 <malloc+0x342>
    3050:	00002097          	auipc	ra,0x2
    3054:	3a8080e7          	jalr	936(ra) # 53f8 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    3058:	20200593          	li	a1,514
    305c:	00003517          	auipc	a0,0x3
    3060:	ad450513          	addi	a0,a0,-1324 # 5b30 <malloc+0x342>
    3064:	00002097          	auipc	ra,0x2
    3068:	384080e7          	jalr	900(ra) # 53e8 <open>
    306c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    306e:	4481                	li	s1,0
    memset(buf, i, SZ);
    3070:	00007917          	auipc	s2,0x7
    3074:	14090913          	addi	s2,s2,320 # a1b0 <buf>
  for(i = 0; i < N; i++){
    3078:	4a51                	li	s4,20
  if(fd < 0){
    307a:	0a054063          	bltz	a0,311a <bigfile+0xe6>
    memset(buf, i, SZ);
    307e:	25800613          	li	a2,600
    3082:	85a6                	mv	a1,s1
    3084:	854a                	mv	a0,s2
    3086:	00002097          	auipc	ra,0x2
    308a:	19e080e7          	jalr	414(ra) # 5224 <memset>
    if(write(fd, buf, SZ) != SZ){
    308e:	25800613          	li	a2,600
    3092:	85ca                	mv	a1,s2
    3094:	854e                	mv	a0,s3
    3096:	00002097          	auipc	ra,0x2
    309a:	332080e7          	jalr	818(ra) # 53c8 <write>
    309e:	25800793          	li	a5,600
    30a2:	08f51a63          	bne	a0,a5,3136 <bigfile+0x102>
  for(i = 0; i < N; i++){
    30a6:	2485                	addiw	s1,s1,1
    30a8:	fd449be3          	bne	s1,s4,307e <bigfile+0x4a>
  close(fd);
    30ac:	854e                	mv	a0,s3
    30ae:	00002097          	auipc	ra,0x2
    30b2:	322080e7          	jalr	802(ra) # 53d0 <close>
  fd = open("bigfile", 0);
    30b6:	4581                	li	a1,0
    30b8:	00003517          	auipc	a0,0x3
    30bc:	a7850513          	addi	a0,a0,-1416 # 5b30 <malloc+0x342>
    30c0:	00002097          	auipc	ra,0x2
    30c4:	328080e7          	jalr	808(ra) # 53e8 <open>
    30c8:	8a2a                	mv	s4,a0
  total = 0;
    30ca:	4981                	li	s3,0
  for(i = 0; ; i++){
    30cc:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    30ce:	00007917          	auipc	s2,0x7
    30d2:	0e290913          	addi	s2,s2,226 # a1b0 <buf>
  if(fd < 0){
    30d6:	06054e63          	bltz	a0,3152 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    30da:	12c00613          	li	a2,300
    30de:	85ca                	mv	a1,s2
    30e0:	8552                	mv	a0,s4
    30e2:	00002097          	auipc	ra,0x2
    30e6:	2de080e7          	jalr	734(ra) # 53c0 <read>
    if(cc < 0){
    30ea:	08054263          	bltz	a0,316e <bigfile+0x13a>
    if(cc == 0)
    30ee:	c971                	beqz	a0,31c2 <bigfile+0x18e>
    if(cc != SZ/2){
    30f0:	12c00793          	li	a5,300
    30f4:	08f51b63          	bne	a0,a5,318a <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    30f8:	01f4d79b          	srliw	a5,s1,0x1f
    30fc:	9fa5                	addw	a5,a5,s1
    30fe:	4017d79b          	sraiw	a5,a5,0x1
    3102:	00094703          	lbu	a4,0(s2)
    3106:	0af71063          	bne	a4,a5,31a6 <bigfile+0x172>
    310a:	12b94703          	lbu	a4,299(s2)
    310e:	08f71c63          	bne	a4,a5,31a6 <bigfile+0x172>
    total += cc;
    3112:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    3116:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    3118:	b7c9                	j	30da <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    311a:	85d6                	mv	a1,s5
    311c:	00003517          	auipc	a0,0x3
    3120:	6d450513          	addi	a0,a0,1748 # 67f0 <malloc+0x1002>
    3124:	00002097          	auipc	ra,0x2
    3128:	60c080e7          	jalr	1548(ra) # 5730 <printf>
    exit(1);
    312c:	4505                	li	a0,1
    312e:	00002097          	auipc	ra,0x2
    3132:	27a080e7          	jalr	634(ra) # 53a8 <exit>
      printf("%s: write bigfile failed\n", s);
    3136:	85d6                	mv	a1,s5
    3138:	00003517          	auipc	a0,0x3
    313c:	6d850513          	addi	a0,a0,1752 # 6810 <malloc+0x1022>
    3140:	00002097          	auipc	ra,0x2
    3144:	5f0080e7          	jalr	1520(ra) # 5730 <printf>
      exit(1);
    3148:	4505                	li	a0,1
    314a:	00002097          	auipc	ra,0x2
    314e:	25e080e7          	jalr	606(ra) # 53a8 <exit>
    printf("%s: cannot open bigfile\n", s);
    3152:	85d6                	mv	a1,s5
    3154:	00003517          	auipc	a0,0x3
    3158:	6dc50513          	addi	a0,a0,1756 # 6830 <malloc+0x1042>
    315c:	00002097          	auipc	ra,0x2
    3160:	5d4080e7          	jalr	1492(ra) # 5730 <printf>
    exit(1);
    3164:	4505                	li	a0,1
    3166:	00002097          	auipc	ra,0x2
    316a:	242080e7          	jalr	578(ra) # 53a8 <exit>
      printf("%s: read bigfile failed\n", s);
    316e:	85d6                	mv	a1,s5
    3170:	00003517          	auipc	a0,0x3
    3174:	6e050513          	addi	a0,a0,1760 # 6850 <malloc+0x1062>
    3178:	00002097          	auipc	ra,0x2
    317c:	5b8080e7          	jalr	1464(ra) # 5730 <printf>
      exit(1);
    3180:	4505                	li	a0,1
    3182:	00002097          	auipc	ra,0x2
    3186:	226080e7          	jalr	550(ra) # 53a8 <exit>
      printf("%s: short read bigfile\n", s);
    318a:	85d6                	mv	a1,s5
    318c:	00003517          	auipc	a0,0x3
    3190:	6e450513          	addi	a0,a0,1764 # 6870 <malloc+0x1082>
    3194:	00002097          	auipc	ra,0x2
    3198:	59c080e7          	jalr	1436(ra) # 5730 <printf>
      exit(1);
    319c:	4505                	li	a0,1
    319e:	00002097          	auipc	ra,0x2
    31a2:	20a080e7          	jalr	522(ra) # 53a8 <exit>
      printf("%s: read bigfile wrong data\n", s);
    31a6:	85d6                	mv	a1,s5
    31a8:	00003517          	auipc	a0,0x3
    31ac:	6e050513          	addi	a0,a0,1760 # 6888 <malloc+0x109a>
    31b0:	00002097          	auipc	ra,0x2
    31b4:	580080e7          	jalr	1408(ra) # 5730 <printf>
      exit(1);
    31b8:	4505                	li	a0,1
    31ba:	00002097          	auipc	ra,0x2
    31be:	1ee080e7          	jalr	494(ra) # 53a8 <exit>
  close(fd);
    31c2:	8552                	mv	a0,s4
    31c4:	00002097          	auipc	ra,0x2
    31c8:	20c080e7          	jalr	524(ra) # 53d0 <close>
  if(total != N*SZ){
    31cc:	678d                	lui	a5,0x3
    31ce:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourfiles+0xe8>
    31d2:	02f99363          	bne	s3,a5,31f8 <bigfile+0x1c4>
  unlink("bigfile");
    31d6:	00003517          	auipc	a0,0x3
    31da:	95a50513          	addi	a0,a0,-1702 # 5b30 <malloc+0x342>
    31de:	00002097          	auipc	ra,0x2
    31e2:	21a080e7          	jalr	538(ra) # 53f8 <unlink>
}
    31e6:	70e2                	ld	ra,56(sp)
    31e8:	7442                	ld	s0,48(sp)
    31ea:	74a2                	ld	s1,40(sp)
    31ec:	7902                	ld	s2,32(sp)
    31ee:	69e2                	ld	s3,24(sp)
    31f0:	6a42                	ld	s4,16(sp)
    31f2:	6aa2                	ld	s5,8(sp)
    31f4:	6121                	addi	sp,sp,64
    31f6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    31f8:	85d6                	mv	a1,s5
    31fa:	00003517          	auipc	a0,0x3
    31fe:	6ae50513          	addi	a0,a0,1710 # 68a8 <malloc+0x10ba>
    3202:	00002097          	auipc	ra,0x2
    3206:	52e080e7          	jalr	1326(ra) # 5730 <printf>
    exit(1);
    320a:	4505                	li	a0,1
    320c:	00002097          	auipc	ra,0x2
    3210:	19c080e7          	jalr	412(ra) # 53a8 <exit>

0000000000003214 <linktest>:
{
    3214:	1101                	addi	sp,sp,-32
    3216:	ec06                	sd	ra,24(sp)
    3218:	e822                	sd	s0,16(sp)
    321a:	e426                	sd	s1,8(sp)
    321c:	e04a                	sd	s2,0(sp)
    321e:	1000                	addi	s0,sp,32
    3220:	892a                	mv	s2,a0
  unlink("lf1");
    3222:	00003517          	auipc	a0,0x3
    3226:	6a650513          	addi	a0,a0,1702 # 68c8 <malloc+0x10da>
    322a:	00002097          	auipc	ra,0x2
    322e:	1ce080e7          	jalr	462(ra) # 53f8 <unlink>
  unlink("lf2");
    3232:	00003517          	auipc	a0,0x3
    3236:	69e50513          	addi	a0,a0,1694 # 68d0 <malloc+0x10e2>
    323a:	00002097          	auipc	ra,0x2
    323e:	1be080e7          	jalr	446(ra) # 53f8 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    3242:	20200593          	li	a1,514
    3246:	00003517          	auipc	a0,0x3
    324a:	68250513          	addi	a0,a0,1666 # 68c8 <malloc+0x10da>
    324e:	00002097          	auipc	ra,0x2
    3252:	19a080e7          	jalr	410(ra) # 53e8 <open>
  if(fd < 0){
    3256:	10054763          	bltz	a0,3364 <linktest+0x150>
    325a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    325c:	4615                	li	a2,5
    325e:	00003597          	auipc	a1,0x3
    3262:	16258593          	addi	a1,a1,354 # 63c0 <malloc+0xbd2>
    3266:	00002097          	auipc	ra,0x2
    326a:	162080e7          	jalr	354(ra) # 53c8 <write>
    326e:	4795                	li	a5,5
    3270:	10f51863          	bne	a0,a5,3380 <linktest+0x16c>
  close(fd);
    3274:	8526                	mv	a0,s1
    3276:	00002097          	auipc	ra,0x2
    327a:	15a080e7          	jalr	346(ra) # 53d0 <close>
  if(link("lf1", "lf2") < 0){
    327e:	00003597          	auipc	a1,0x3
    3282:	65258593          	addi	a1,a1,1618 # 68d0 <malloc+0x10e2>
    3286:	00003517          	auipc	a0,0x3
    328a:	64250513          	addi	a0,a0,1602 # 68c8 <malloc+0x10da>
    328e:	00002097          	auipc	ra,0x2
    3292:	17a080e7          	jalr	378(ra) # 5408 <link>
    3296:	10054363          	bltz	a0,339c <linktest+0x188>
  unlink("lf1");
    329a:	00003517          	auipc	a0,0x3
    329e:	62e50513          	addi	a0,a0,1582 # 68c8 <malloc+0x10da>
    32a2:	00002097          	auipc	ra,0x2
    32a6:	156080e7          	jalr	342(ra) # 53f8 <unlink>
  if(open("lf1", 0) >= 0){
    32aa:	4581                	li	a1,0
    32ac:	00003517          	auipc	a0,0x3
    32b0:	61c50513          	addi	a0,a0,1564 # 68c8 <malloc+0x10da>
    32b4:	00002097          	auipc	ra,0x2
    32b8:	134080e7          	jalr	308(ra) # 53e8 <open>
    32bc:	0e055e63          	bgez	a0,33b8 <linktest+0x1a4>
  fd = open("lf2", 0);
    32c0:	4581                	li	a1,0
    32c2:	00003517          	auipc	a0,0x3
    32c6:	60e50513          	addi	a0,a0,1550 # 68d0 <malloc+0x10e2>
    32ca:	00002097          	auipc	ra,0x2
    32ce:	11e080e7          	jalr	286(ra) # 53e8 <open>
    32d2:	84aa                	mv	s1,a0
  if(fd < 0){
    32d4:	10054063          	bltz	a0,33d4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    32d8:	660d                	lui	a2,0x3
    32da:	00007597          	auipc	a1,0x7
    32de:	ed658593          	addi	a1,a1,-298 # a1b0 <buf>
    32e2:	00002097          	auipc	ra,0x2
    32e6:	0de080e7          	jalr	222(ra) # 53c0 <read>
    32ea:	4795                	li	a5,5
    32ec:	10f51263          	bne	a0,a5,33f0 <linktest+0x1dc>
  close(fd);
    32f0:	8526                	mv	a0,s1
    32f2:	00002097          	auipc	ra,0x2
    32f6:	0de080e7          	jalr	222(ra) # 53d0 <close>
  if(link("lf2", "lf2") >= 0){
    32fa:	00003597          	auipc	a1,0x3
    32fe:	5d658593          	addi	a1,a1,1494 # 68d0 <malloc+0x10e2>
    3302:	852e                	mv	a0,a1
    3304:	00002097          	auipc	ra,0x2
    3308:	104080e7          	jalr	260(ra) # 5408 <link>
    330c:	10055063          	bgez	a0,340c <linktest+0x1f8>
  unlink("lf2");
    3310:	00003517          	auipc	a0,0x3
    3314:	5c050513          	addi	a0,a0,1472 # 68d0 <malloc+0x10e2>
    3318:	00002097          	auipc	ra,0x2
    331c:	0e0080e7          	jalr	224(ra) # 53f8 <unlink>
  if(link("lf2", "lf1") >= 0){
    3320:	00003597          	auipc	a1,0x3
    3324:	5a858593          	addi	a1,a1,1448 # 68c8 <malloc+0x10da>
    3328:	00003517          	auipc	a0,0x3
    332c:	5a850513          	addi	a0,a0,1448 # 68d0 <malloc+0x10e2>
    3330:	00002097          	auipc	ra,0x2
    3334:	0d8080e7          	jalr	216(ra) # 5408 <link>
    3338:	0e055863          	bgez	a0,3428 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    333c:	00003597          	auipc	a1,0x3
    3340:	58c58593          	addi	a1,a1,1420 # 68c8 <malloc+0x10da>
    3344:	00003517          	auipc	a0,0x3
    3348:	8fc50513          	addi	a0,a0,-1796 # 5c40 <malloc+0x452>
    334c:	00002097          	auipc	ra,0x2
    3350:	0bc080e7          	jalr	188(ra) # 5408 <link>
    3354:	0e055863          	bgez	a0,3444 <linktest+0x230>
}
    3358:	60e2                	ld	ra,24(sp)
    335a:	6442                	ld	s0,16(sp)
    335c:	64a2                	ld	s1,8(sp)
    335e:	6902                	ld	s2,0(sp)
    3360:	6105                	addi	sp,sp,32
    3362:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    3364:	85ca                	mv	a1,s2
    3366:	00003517          	auipc	a0,0x3
    336a:	57250513          	addi	a0,a0,1394 # 68d8 <malloc+0x10ea>
    336e:	00002097          	auipc	ra,0x2
    3372:	3c2080e7          	jalr	962(ra) # 5730 <printf>
    exit(1);
    3376:	4505                	li	a0,1
    3378:	00002097          	auipc	ra,0x2
    337c:	030080e7          	jalr	48(ra) # 53a8 <exit>
    printf("%s: write lf1 failed\n", s);
    3380:	85ca                	mv	a1,s2
    3382:	00003517          	auipc	a0,0x3
    3386:	56e50513          	addi	a0,a0,1390 # 68f0 <malloc+0x1102>
    338a:	00002097          	auipc	ra,0x2
    338e:	3a6080e7          	jalr	934(ra) # 5730 <printf>
    exit(1);
    3392:	4505                	li	a0,1
    3394:	00002097          	auipc	ra,0x2
    3398:	014080e7          	jalr	20(ra) # 53a8 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    339c:	85ca                	mv	a1,s2
    339e:	00003517          	auipc	a0,0x3
    33a2:	56a50513          	addi	a0,a0,1386 # 6908 <malloc+0x111a>
    33a6:	00002097          	auipc	ra,0x2
    33aa:	38a080e7          	jalr	906(ra) # 5730 <printf>
    exit(1);
    33ae:	4505                	li	a0,1
    33b0:	00002097          	auipc	ra,0x2
    33b4:	ff8080e7          	jalr	-8(ra) # 53a8 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    33b8:	85ca                	mv	a1,s2
    33ba:	00003517          	auipc	a0,0x3
    33be:	56e50513          	addi	a0,a0,1390 # 6928 <malloc+0x113a>
    33c2:	00002097          	auipc	ra,0x2
    33c6:	36e080e7          	jalr	878(ra) # 5730 <printf>
    exit(1);
    33ca:	4505                	li	a0,1
    33cc:	00002097          	auipc	ra,0x2
    33d0:	fdc080e7          	jalr	-36(ra) # 53a8 <exit>
    printf("%s: open lf2 failed\n", s);
    33d4:	85ca                	mv	a1,s2
    33d6:	00003517          	auipc	a0,0x3
    33da:	58250513          	addi	a0,a0,1410 # 6958 <malloc+0x116a>
    33de:	00002097          	auipc	ra,0x2
    33e2:	352080e7          	jalr	850(ra) # 5730 <printf>
    exit(1);
    33e6:	4505                	li	a0,1
    33e8:	00002097          	auipc	ra,0x2
    33ec:	fc0080e7          	jalr	-64(ra) # 53a8 <exit>
    printf("%s: read lf2 failed\n", s);
    33f0:	85ca                	mv	a1,s2
    33f2:	00003517          	auipc	a0,0x3
    33f6:	57e50513          	addi	a0,a0,1406 # 6970 <malloc+0x1182>
    33fa:	00002097          	auipc	ra,0x2
    33fe:	336080e7          	jalr	822(ra) # 5730 <printf>
    exit(1);
    3402:	4505                	li	a0,1
    3404:	00002097          	auipc	ra,0x2
    3408:	fa4080e7          	jalr	-92(ra) # 53a8 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    340c:	85ca                	mv	a1,s2
    340e:	00003517          	auipc	a0,0x3
    3412:	57a50513          	addi	a0,a0,1402 # 6988 <malloc+0x119a>
    3416:	00002097          	auipc	ra,0x2
    341a:	31a080e7          	jalr	794(ra) # 5730 <printf>
    exit(1);
    341e:	4505                	li	a0,1
    3420:	00002097          	auipc	ra,0x2
    3424:	f88080e7          	jalr	-120(ra) # 53a8 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
    3428:	85ca                	mv	a1,s2
    342a:	00003517          	auipc	a0,0x3
    342e:	58650513          	addi	a0,a0,1414 # 69b0 <malloc+0x11c2>
    3432:	00002097          	auipc	ra,0x2
    3436:	2fe080e7          	jalr	766(ra) # 5730 <printf>
    exit(1);
    343a:	4505                	li	a0,1
    343c:	00002097          	auipc	ra,0x2
    3440:	f6c080e7          	jalr	-148(ra) # 53a8 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    3444:	85ca                	mv	a1,s2
    3446:	00003517          	auipc	a0,0x3
    344a:	59250513          	addi	a0,a0,1426 # 69d8 <malloc+0x11ea>
    344e:	00002097          	auipc	ra,0x2
    3452:	2e2080e7          	jalr	738(ra) # 5730 <printf>
    exit(1);
    3456:	4505                	li	a0,1
    3458:	00002097          	auipc	ra,0x2
    345c:	f50080e7          	jalr	-176(ra) # 53a8 <exit>

0000000000003460 <concreate>:
{
    3460:	7135                	addi	sp,sp,-160
    3462:	ed06                	sd	ra,152(sp)
    3464:	e922                	sd	s0,144(sp)
    3466:	e526                	sd	s1,136(sp)
    3468:	e14a                	sd	s2,128(sp)
    346a:	fcce                	sd	s3,120(sp)
    346c:	f8d2                	sd	s4,112(sp)
    346e:	f4d6                	sd	s5,104(sp)
    3470:	f0da                	sd	s6,96(sp)
    3472:	ecde                	sd	s7,88(sp)
    3474:	1100                	addi	s0,sp,160
    3476:	89aa                	mv	s3,a0
  file[0] = 'C';
    3478:	04300793          	li	a5,67
    347c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3480:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3484:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3486:	4b0d                	li	s6,3
    3488:	4a85                	li	s5,1
      link("C0", file);
    348a:	00003b97          	auipc	s7,0x3
    348e:	56eb8b93          	addi	s7,s7,1390 # 69f8 <malloc+0x120a>
  for(i = 0; i < N; i++){
    3492:	02800a13          	li	s4,40
    3496:	a471                	j	3722 <concreate+0x2c2>
      link("C0", file);
    3498:	fa840593          	addi	a1,s0,-88
    349c:	855e                	mv	a0,s7
    349e:	00002097          	auipc	ra,0x2
    34a2:	f6a080e7          	jalr	-150(ra) # 5408 <link>
    if(pid == 0) {
    34a6:	a48d                	j	3708 <concreate+0x2a8>
    } else if(pid == 0 && (i % 5) == 1){
    34a8:	4795                	li	a5,5
    34aa:	02f9693b          	remw	s2,s2,a5
    34ae:	4785                	li	a5,1
    34b0:	02f90b63          	beq	s2,a5,34e6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    34b4:	20200593          	li	a1,514
    34b8:	fa840513          	addi	a0,s0,-88
    34bc:	00002097          	auipc	ra,0x2
    34c0:	f2c080e7          	jalr	-212(ra) # 53e8 <open>
      if(fd < 0){
    34c4:	22055963          	bgez	a0,36f6 <concreate+0x296>
        printf("concreate create %s failed\n", file);
    34c8:	fa840593          	addi	a1,s0,-88
    34cc:	00003517          	auipc	a0,0x3
    34d0:	53450513          	addi	a0,a0,1332 # 6a00 <malloc+0x1212>
    34d4:	00002097          	auipc	ra,0x2
    34d8:	25c080e7          	jalr	604(ra) # 5730 <printf>
        exit(1);
    34dc:	4505                	li	a0,1
    34de:	00002097          	auipc	ra,0x2
    34e2:	eca080e7          	jalr	-310(ra) # 53a8 <exit>
      link("C0", file);
    34e6:	fa840593          	addi	a1,s0,-88
    34ea:	00003517          	auipc	a0,0x3
    34ee:	50e50513          	addi	a0,a0,1294 # 69f8 <malloc+0x120a>
    34f2:	00002097          	auipc	ra,0x2
    34f6:	f16080e7          	jalr	-234(ra) # 5408 <link>
      exit(0);
    34fa:	4501                	li	a0,0
    34fc:	00002097          	auipc	ra,0x2
    3500:	eac080e7          	jalr	-340(ra) # 53a8 <exit>
        exit(1);
    3504:	4505                	li	a0,1
    3506:	00002097          	auipc	ra,0x2
    350a:	ea2080e7          	jalr	-350(ra) # 53a8 <exit>
  memset(fa, 0, sizeof(fa));
    350e:	02800613          	li	a2,40
    3512:	4581                	li	a1,0
    3514:	f8040513          	addi	a0,s0,-128
    3518:	00002097          	auipc	ra,0x2
    351c:	d0c080e7          	jalr	-756(ra) # 5224 <memset>
  fd = open(".", 0);
    3520:	4581                	li	a1,0
    3522:	00002517          	auipc	a0,0x2
    3526:	71e50513          	addi	a0,a0,1822 # 5c40 <malloc+0x452>
    352a:	00002097          	auipc	ra,0x2
    352e:	ebe080e7          	jalr	-322(ra) # 53e8 <open>
    3532:	892a                	mv	s2,a0
  n = 0;
    3534:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3536:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    353a:	02700b13          	li	s6,39
      fa[i] = 1;
    353e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3540:	a03d                	j	356e <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    3542:	f7240613          	addi	a2,s0,-142
    3546:	85ce                	mv	a1,s3
    3548:	00003517          	auipc	a0,0x3
    354c:	4d850513          	addi	a0,a0,1240 # 6a20 <malloc+0x1232>
    3550:	00002097          	auipc	ra,0x2
    3554:	1e0080e7          	jalr	480(ra) # 5730 <printf>
        exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	e4e080e7          	jalr	-434(ra) # 53a8 <exit>
      fa[i] = 1;
    3562:	fb040793          	addi	a5,s0,-80
    3566:	973e                	add	a4,a4,a5
    3568:	fd770823          	sb	s7,-48(a4)
      n++;
    356c:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    356e:	4641                	li	a2,16
    3570:	f7040593          	addi	a1,s0,-144
    3574:	854a                	mv	a0,s2
    3576:	00002097          	auipc	ra,0x2
    357a:	e4a080e7          	jalr	-438(ra) # 53c0 <read>
    357e:	04a05a63          	blez	a0,35d2 <concreate+0x172>
    if(de.inum == 0)
    3582:	f7045783          	lhu	a5,-144(s0)
    3586:	d7e5                	beqz	a5,356e <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3588:	f7244783          	lbu	a5,-142(s0)
    358c:	ff4791e3          	bne	a5,s4,356e <concreate+0x10e>
    3590:	f7444783          	lbu	a5,-140(s0)
    3594:	ffe9                	bnez	a5,356e <concreate+0x10e>
      i = de.name[1] - '0';
    3596:	f7344783          	lbu	a5,-141(s0)
    359a:	fd07879b          	addiw	a5,a5,-48
    359e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    35a2:	faeb60e3          	bltu	s6,a4,3542 <concreate+0xe2>
      if(fa[i]){
    35a6:	fb040793          	addi	a5,s0,-80
    35aa:	97ba                	add	a5,a5,a4
    35ac:	fd07c783          	lbu	a5,-48(a5)
    35b0:	dbcd                	beqz	a5,3562 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    35b2:	f7240613          	addi	a2,s0,-142
    35b6:	85ce                	mv	a1,s3
    35b8:	00003517          	auipc	a0,0x3
    35bc:	48850513          	addi	a0,a0,1160 # 6a40 <malloc+0x1252>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	170080e7          	jalr	368(ra) # 5730 <printf>
        exit(1);
    35c8:	4505                	li	a0,1
    35ca:	00002097          	auipc	ra,0x2
    35ce:	dde080e7          	jalr	-546(ra) # 53a8 <exit>
  close(fd);
    35d2:	854a                	mv	a0,s2
    35d4:	00002097          	auipc	ra,0x2
    35d8:	dfc080e7          	jalr	-516(ra) # 53d0 <close>
  if(n != N){
    35dc:	02800793          	li	a5,40
    35e0:	00fa9763          	bne	s5,a5,35ee <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    35e4:	4a8d                	li	s5,3
    35e6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    35e8:	02800a13          	li	s4,40
    35ec:	a05d                	j	3692 <concreate+0x232>
    printf("%s: concreate not enough files in directory listing\n", s);
    35ee:	85ce                	mv	a1,s3
    35f0:	00003517          	auipc	a0,0x3
    35f4:	47850513          	addi	a0,a0,1144 # 6a68 <malloc+0x127a>
    35f8:	00002097          	auipc	ra,0x2
    35fc:	138080e7          	jalr	312(ra) # 5730 <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00002097          	auipc	ra,0x2
    3606:	da6080e7          	jalr	-602(ra) # 53a8 <exit>
      printf("%s: fork failed\n", s);
    360a:	85ce                	mv	a1,s3
    360c:	00002517          	auipc	a0,0x2
    3610:	6e450513          	addi	a0,a0,1764 # 5cf0 <malloc+0x502>
    3614:	00002097          	auipc	ra,0x2
    3618:	11c080e7          	jalr	284(ra) # 5730 <printf>
      exit(1);
    361c:	4505                	li	a0,1
    361e:	00002097          	auipc	ra,0x2
    3622:	d8a080e7          	jalr	-630(ra) # 53a8 <exit>
      close(open(file, 0));
    3626:	4581                	li	a1,0
    3628:	fa840513          	addi	a0,s0,-88
    362c:	00002097          	auipc	ra,0x2
    3630:	dbc080e7          	jalr	-580(ra) # 53e8 <open>
    3634:	00002097          	auipc	ra,0x2
    3638:	d9c080e7          	jalr	-612(ra) # 53d0 <close>
      close(open(file, 0));
    363c:	4581                	li	a1,0
    363e:	fa840513          	addi	a0,s0,-88
    3642:	00002097          	auipc	ra,0x2
    3646:	da6080e7          	jalr	-602(ra) # 53e8 <open>
    364a:	00002097          	auipc	ra,0x2
    364e:	d86080e7          	jalr	-634(ra) # 53d0 <close>
      close(open(file, 0));
    3652:	4581                	li	a1,0
    3654:	fa840513          	addi	a0,s0,-88
    3658:	00002097          	auipc	ra,0x2
    365c:	d90080e7          	jalr	-624(ra) # 53e8 <open>
    3660:	00002097          	auipc	ra,0x2
    3664:	d70080e7          	jalr	-656(ra) # 53d0 <close>
      close(open(file, 0));
    3668:	4581                	li	a1,0
    366a:	fa840513          	addi	a0,s0,-88
    366e:	00002097          	auipc	ra,0x2
    3672:	d7a080e7          	jalr	-646(ra) # 53e8 <open>
    3676:	00002097          	auipc	ra,0x2
    367a:	d5a080e7          	jalr	-678(ra) # 53d0 <close>
    if(pid == 0)
    367e:	06090763          	beqz	s2,36ec <concreate+0x28c>
      wait(0);
    3682:	4501                	li	a0,0
    3684:	00002097          	auipc	ra,0x2
    3688:	d2c080e7          	jalr	-724(ra) # 53b0 <wait>
  for(i = 0; i < N; i++){
    368c:	2485                	addiw	s1,s1,1
    368e:	0d448963          	beq	s1,s4,3760 <concreate+0x300>
    file[1] = '0' + i;
    3692:	0304879b          	addiw	a5,s1,48
    3696:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    369a:	00002097          	auipc	ra,0x2
    369e:	d06080e7          	jalr	-762(ra) # 53a0 <fork>
    36a2:	892a                	mv	s2,a0
    if(pid < 0){
    36a4:	f60543e3          	bltz	a0,360a <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    36a8:	0354e73b          	remw	a4,s1,s5
    36ac:	00a767b3          	or	a5,a4,a0
    36b0:	2781                	sext.w	a5,a5
    36b2:	dbb5                	beqz	a5,3626 <concreate+0x1c6>
    36b4:	01671363          	bne	a4,s6,36ba <concreate+0x25a>
       ((i % 3) == 1 && pid != 0)){
    36b8:	f53d                	bnez	a0,3626 <concreate+0x1c6>
      unlink(file);
    36ba:	fa840513          	addi	a0,s0,-88
    36be:	00002097          	auipc	ra,0x2
    36c2:	d3a080e7          	jalr	-710(ra) # 53f8 <unlink>
      unlink(file);
    36c6:	fa840513          	addi	a0,s0,-88
    36ca:	00002097          	auipc	ra,0x2
    36ce:	d2e080e7          	jalr	-722(ra) # 53f8 <unlink>
      unlink(file);
    36d2:	fa840513          	addi	a0,s0,-88
    36d6:	00002097          	auipc	ra,0x2
    36da:	d22080e7          	jalr	-734(ra) # 53f8 <unlink>
      unlink(file);
    36de:	fa840513          	addi	a0,s0,-88
    36e2:	00002097          	auipc	ra,0x2
    36e6:	d16080e7          	jalr	-746(ra) # 53f8 <unlink>
    36ea:	bf51                	j	367e <concreate+0x21e>
      exit(0);
    36ec:	4501                	li	a0,0
    36ee:	00002097          	auipc	ra,0x2
    36f2:	cba080e7          	jalr	-838(ra) # 53a8 <exit>
      close(fd);
    36f6:	00002097          	auipc	ra,0x2
    36fa:	cda080e7          	jalr	-806(ra) # 53d0 <close>
    if(pid == 0) {
    36fe:	bbf5                	j	34fa <concreate+0x9a>
      close(fd);
    3700:	00002097          	auipc	ra,0x2
    3704:	cd0080e7          	jalr	-816(ra) # 53d0 <close>
      wait(&xstatus);
    3708:	f6c40513          	addi	a0,s0,-148
    370c:	00002097          	auipc	ra,0x2
    3710:	ca4080e7          	jalr	-860(ra) # 53b0 <wait>
      if(xstatus != 0)
    3714:	f6c42483          	lw	s1,-148(s0)
    3718:	de0496e3          	bnez	s1,3504 <concreate+0xa4>
  for(i = 0; i < N; i++){
    371c:	2905                	addiw	s2,s2,1
    371e:	df4908e3          	beq	s2,s4,350e <concreate+0xae>
    file[1] = '0' + i;
    3722:	0309079b          	addiw	a5,s2,48
    3726:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    372a:	fa840513          	addi	a0,s0,-88
    372e:	00002097          	auipc	ra,0x2
    3732:	cca080e7          	jalr	-822(ra) # 53f8 <unlink>
    pid = fork();
    3736:	00002097          	auipc	ra,0x2
    373a:	c6a080e7          	jalr	-918(ra) # 53a0 <fork>
    if(pid && (i % 3) == 1){
    373e:	d60505e3          	beqz	a0,34a8 <concreate+0x48>
    3742:	036967bb          	remw	a5,s2,s6
    3746:	d55789e3          	beq	a5,s5,3498 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    374a:	20200593          	li	a1,514
    374e:	fa840513          	addi	a0,s0,-88
    3752:	00002097          	auipc	ra,0x2
    3756:	c96080e7          	jalr	-874(ra) # 53e8 <open>
      if(fd < 0){
    375a:	fa0553e3          	bgez	a0,3700 <concreate+0x2a0>
    375e:	b3ad                	j	34c8 <concreate+0x68>
}
    3760:	60ea                	ld	ra,152(sp)
    3762:	644a                	ld	s0,144(sp)
    3764:	64aa                	ld	s1,136(sp)
    3766:	690a                	ld	s2,128(sp)
    3768:	79e6                	ld	s3,120(sp)
    376a:	7a46                	ld	s4,112(sp)
    376c:	7aa6                	ld	s5,104(sp)
    376e:	7b06                	ld	s6,96(sp)
    3770:	6be6                	ld	s7,88(sp)
    3772:	610d                	addi	sp,sp,160
    3774:	8082                	ret

0000000000003776 <linkunlink>:
{
    3776:	711d                	addi	sp,sp,-96
    3778:	ec86                	sd	ra,88(sp)
    377a:	e8a2                	sd	s0,80(sp)
    377c:	e4a6                	sd	s1,72(sp)
    377e:	e0ca                	sd	s2,64(sp)
    3780:	fc4e                	sd	s3,56(sp)
    3782:	f852                	sd	s4,48(sp)
    3784:	f456                	sd	s5,40(sp)
    3786:	f05a                	sd	s6,32(sp)
    3788:	ec5e                	sd	s7,24(sp)
    378a:	e862                	sd	s8,16(sp)
    378c:	e466                	sd	s9,8(sp)
    378e:	1080                	addi	s0,sp,96
    3790:	84aa                	mv	s1,a0
  unlink("x");
    3792:	00003517          	auipc	a0,0x3
    3796:	f0e50513          	addi	a0,a0,-242 # 66a0 <malloc+0xeb2>
    379a:	00002097          	auipc	ra,0x2
    379e:	c5e080e7          	jalr	-930(ra) # 53f8 <unlink>
  pid = fork();
    37a2:	00002097          	auipc	ra,0x2
    37a6:	bfe080e7          	jalr	-1026(ra) # 53a0 <fork>
  if(pid < 0){
    37aa:	02054b63          	bltz	a0,37e0 <linkunlink+0x6a>
    37ae:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    37b0:	4c85                	li	s9,1
    37b2:	e119                	bnez	a0,37b8 <linkunlink+0x42>
    37b4:	06100c93          	li	s9,97
    37b8:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    37bc:	41c659b7          	lui	s3,0x41c65
    37c0:	e6d9899b          	addiw	s3,s3,-403
    37c4:	690d                	lui	s2,0x3
    37c6:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    37ca:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    37cc:	4b05                	li	s6,1
      unlink("x");
    37ce:	00003a97          	auipc	s5,0x3
    37d2:	ed2a8a93          	addi	s5,s5,-302 # 66a0 <malloc+0xeb2>
      link("cat", "x");
    37d6:	00003b97          	auipc	s7,0x3
    37da:	2cab8b93          	addi	s7,s7,714 # 6aa0 <malloc+0x12b2>
    37de:	a091                	j	3822 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    37e0:	85a6                	mv	a1,s1
    37e2:	00002517          	auipc	a0,0x2
    37e6:	50e50513          	addi	a0,a0,1294 # 5cf0 <malloc+0x502>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	f46080e7          	jalr	-186(ra) # 5730 <printf>
    exit(1);
    37f2:	4505                	li	a0,1
    37f4:	00002097          	auipc	ra,0x2
    37f8:	bb4080e7          	jalr	-1100(ra) # 53a8 <exit>
      close(open("x", O_RDWR | O_CREATE));
    37fc:	20200593          	li	a1,514
    3800:	8556                	mv	a0,s5
    3802:	00002097          	auipc	ra,0x2
    3806:	be6080e7          	jalr	-1050(ra) # 53e8 <open>
    380a:	00002097          	auipc	ra,0x2
    380e:	bc6080e7          	jalr	-1082(ra) # 53d0 <close>
    3812:	a031                	j	381e <linkunlink+0xa8>
      unlink("x");
    3814:	8556                	mv	a0,s5
    3816:	00002097          	auipc	ra,0x2
    381a:	be2080e7          	jalr	-1054(ra) # 53f8 <unlink>
  for(i = 0; i < 100; i++){
    381e:	34fd                	addiw	s1,s1,-1
    3820:	c09d                	beqz	s1,3846 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    3822:	033c87bb          	mulw	a5,s9,s3
    3826:	012787bb          	addw	a5,a5,s2
    382a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    382e:	0347f7bb          	remuw	a5,a5,s4
    3832:	d7e9                	beqz	a5,37fc <linkunlink+0x86>
    } else if((x % 3) == 1){
    3834:	ff6790e3          	bne	a5,s6,3814 <linkunlink+0x9e>
      link("cat", "x");
    3838:	85d6                	mv	a1,s5
    383a:	855e                	mv	a0,s7
    383c:	00002097          	auipc	ra,0x2
    3840:	bcc080e7          	jalr	-1076(ra) # 5408 <link>
    3844:	bfe9                	j	381e <linkunlink+0xa8>
  if(pid)
    3846:	020c0463          	beqz	s8,386e <linkunlink+0xf8>
    wait(0);
    384a:	4501                	li	a0,0
    384c:	00002097          	auipc	ra,0x2
    3850:	b64080e7          	jalr	-1180(ra) # 53b0 <wait>
}
    3854:	60e6                	ld	ra,88(sp)
    3856:	6446                	ld	s0,80(sp)
    3858:	64a6                	ld	s1,72(sp)
    385a:	6906                	ld	s2,64(sp)
    385c:	79e2                	ld	s3,56(sp)
    385e:	7a42                	ld	s4,48(sp)
    3860:	7aa2                	ld	s5,40(sp)
    3862:	7b02                	ld	s6,32(sp)
    3864:	6be2                	ld	s7,24(sp)
    3866:	6c42                	ld	s8,16(sp)
    3868:	6ca2                	ld	s9,8(sp)
    386a:	6125                	addi	sp,sp,96
    386c:	8082                	ret
    exit(0);
    386e:	4501                	li	a0,0
    3870:	00002097          	auipc	ra,0x2
    3874:	b38080e7          	jalr	-1224(ra) # 53a8 <exit>

0000000000003878 <bigdir>:
{
    3878:	715d                	addi	sp,sp,-80
    387a:	e486                	sd	ra,72(sp)
    387c:	e0a2                	sd	s0,64(sp)
    387e:	fc26                	sd	s1,56(sp)
    3880:	f84a                	sd	s2,48(sp)
    3882:	f44e                	sd	s3,40(sp)
    3884:	f052                	sd	s4,32(sp)
    3886:	ec56                	sd	s5,24(sp)
    3888:	e85a                	sd	s6,16(sp)
    388a:	0880                	addi	s0,sp,80
    388c:	89aa                	mv	s3,a0
  unlink("bd");
    388e:	00003517          	auipc	a0,0x3
    3892:	21a50513          	addi	a0,a0,538 # 6aa8 <malloc+0x12ba>
    3896:	00002097          	auipc	ra,0x2
    389a:	b62080e7          	jalr	-1182(ra) # 53f8 <unlink>
  fd = open("bd", O_CREATE);
    389e:	20000593          	li	a1,512
    38a2:	00003517          	auipc	a0,0x3
    38a6:	20650513          	addi	a0,a0,518 # 6aa8 <malloc+0x12ba>
    38aa:	00002097          	auipc	ra,0x2
    38ae:	b3e080e7          	jalr	-1218(ra) # 53e8 <open>
  if(fd < 0){
    38b2:	0c054963          	bltz	a0,3984 <bigdir+0x10c>
  close(fd);
    38b6:	00002097          	auipc	ra,0x2
    38ba:	b1a080e7          	jalr	-1254(ra) # 53d0 <close>
  for(i = 0; i < N; i++){
    38be:	4901                	li	s2,0
    name[0] = 'x';
    38c0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    38c4:	00003a17          	auipc	s4,0x3
    38c8:	1e4a0a13          	addi	s4,s4,484 # 6aa8 <malloc+0x12ba>
  for(i = 0; i < N; i++){
    38cc:	1f400b13          	li	s6,500
    name[0] = 'x';
    38d0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    38d4:	41f9579b          	sraiw	a5,s2,0x1f
    38d8:	01a7d71b          	srliw	a4,a5,0x1a
    38dc:	012707bb          	addw	a5,a4,s2
    38e0:	4067d69b          	sraiw	a3,a5,0x6
    38e4:	0306869b          	addiw	a3,a3,48
    38e8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    38ec:	03f7f793          	andi	a5,a5,63
    38f0:	9f99                	subw	a5,a5,a4
    38f2:	0307879b          	addiw	a5,a5,48
    38f6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    38fa:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    38fe:	fb040593          	addi	a1,s0,-80
    3902:	8552                	mv	a0,s4
    3904:	00002097          	auipc	ra,0x2
    3908:	b04080e7          	jalr	-1276(ra) # 5408 <link>
    390c:	84aa                	mv	s1,a0
    390e:	e949                	bnez	a0,39a0 <bigdir+0x128>
  for(i = 0; i < N; i++){
    3910:	2905                	addiw	s2,s2,1
    3912:	fb691fe3          	bne	s2,s6,38d0 <bigdir+0x58>
  unlink("bd");
    3916:	00003517          	auipc	a0,0x3
    391a:	19250513          	addi	a0,a0,402 # 6aa8 <malloc+0x12ba>
    391e:	00002097          	auipc	ra,0x2
    3922:	ada080e7          	jalr	-1318(ra) # 53f8 <unlink>
    name[0] = 'x';
    3926:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    392a:	1f400a13          	li	s4,500
    name[0] = 'x';
    392e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    3932:	41f4d79b          	sraiw	a5,s1,0x1f
    3936:	01a7d71b          	srliw	a4,a5,0x1a
    393a:	009707bb          	addw	a5,a4,s1
    393e:	4067d69b          	sraiw	a3,a5,0x6
    3942:	0306869b          	addiw	a3,a3,48
    3946:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    394a:	03f7f793          	andi	a5,a5,63
    394e:	9f99                	subw	a5,a5,a4
    3950:	0307879b          	addiw	a5,a5,48
    3954:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    3958:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    395c:	fb040513          	addi	a0,s0,-80
    3960:	00002097          	auipc	ra,0x2
    3964:	a98080e7          	jalr	-1384(ra) # 53f8 <unlink>
    3968:	e931                	bnez	a0,39bc <bigdir+0x144>
  for(i = 0; i < N; i++){
    396a:	2485                	addiw	s1,s1,1
    396c:	fd4491e3          	bne	s1,s4,392e <bigdir+0xb6>
}
    3970:	60a6                	ld	ra,72(sp)
    3972:	6406                	ld	s0,64(sp)
    3974:	74e2                	ld	s1,56(sp)
    3976:	7942                	ld	s2,48(sp)
    3978:	79a2                	ld	s3,40(sp)
    397a:	7a02                	ld	s4,32(sp)
    397c:	6ae2                	ld	s5,24(sp)
    397e:	6b42                	ld	s6,16(sp)
    3980:	6161                	addi	sp,sp,80
    3982:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    3984:	85ce                	mv	a1,s3
    3986:	00003517          	auipc	a0,0x3
    398a:	12a50513          	addi	a0,a0,298 # 6ab0 <malloc+0x12c2>
    398e:	00002097          	auipc	ra,0x2
    3992:	da2080e7          	jalr	-606(ra) # 5730 <printf>
    exit(1);
    3996:	4505                	li	a0,1
    3998:	00002097          	auipc	ra,0x2
    399c:	a10080e7          	jalr	-1520(ra) # 53a8 <exit>
      printf("%s: bigdir link failed\n", s);
    39a0:	85ce                	mv	a1,s3
    39a2:	00003517          	auipc	a0,0x3
    39a6:	12e50513          	addi	a0,a0,302 # 6ad0 <malloc+0x12e2>
    39aa:	00002097          	auipc	ra,0x2
    39ae:	d86080e7          	jalr	-634(ra) # 5730 <printf>
      exit(1);
    39b2:	4505                	li	a0,1
    39b4:	00002097          	auipc	ra,0x2
    39b8:	9f4080e7          	jalr	-1548(ra) # 53a8 <exit>
      printf("%s: bigdir unlink failed", s);
    39bc:	85ce                	mv	a1,s3
    39be:	00003517          	auipc	a0,0x3
    39c2:	12a50513          	addi	a0,a0,298 # 6ae8 <malloc+0x12fa>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	d6a080e7          	jalr	-662(ra) # 5730 <printf>
      exit(1);
    39ce:	4505                	li	a0,1
    39d0:	00002097          	auipc	ra,0x2
    39d4:	9d8080e7          	jalr	-1576(ra) # 53a8 <exit>

00000000000039d8 <subdir>:
{
    39d8:	1101                	addi	sp,sp,-32
    39da:	ec06                	sd	ra,24(sp)
    39dc:	e822                	sd	s0,16(sp)
    39de:	e426                	sd	s1,8(sp)
    39e0:	e04a                	sd	s2,0(sp)
    39e2:	1000                	addi	s0,sp,32
    39e4:	892a                	mv	s2,a0
  unlink("ff");
    39e6:	00003517          	auipc	a0,0x3
    39ea:	25250513          	addi	a0,a0,594 # 6c38 <malloc+0x144a>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	a0a080e7          	jalr	-1526(ra) # 53f8 <unlink>
  if(mkdir("dd") != 0){
    39f6:	00003517          	auipc	a0,0x3
    39fa:	11250513          	addi	a0,a0,274 # 6b08 <malloc+0x131a>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	a12080e7          	jalr	-1518(ra) # 5410 <mkdir>
    3a06:	38051663          	bnez	a0,3d92 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3a0a:	20200593          	li	a1,514
    3a0e:	00003517          	auipc	a0,0x3
    3a12:	11a50513          	addi	a0,a0,282 # 6b28 <malloc+0x133a>
    3a16:	00002097          	auipc	ra,0x2
    3a1a:	9d2080e7          	jalr	-1582(ra) # 53e8 <open>
    3a1e:	84aa                	mv	s1,a0
  if(fd < 0){
    3a20:	38054763          	bltz	a0,3dae <subdir+0x3d6>
  write(fd, "ff", 2);
    3a24:	4609                	li	a2,2
    3a26:	00003597          	auipc	a1,0x3
    3a2a:	21258593          	addi	a1,a1,530 # 6c38 <malloc+0x144a>
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	99a080e7          	jalr	-1638(ra) # 53c8 <write>
  close(fd);
    3a36:	8526                	mv	a0,s1
    3a38:	00002097          	auipc	ra,0x2
    3a3c:	998080e7          	jalr	-1640(ra) # 53d0 <close>
  if(unlink("dd") >= 0){
    3a40:	00003517          	auipc	a0,0x3
    3a44:	0c850513          	addi	a0,a0,200 # 6b08 <malloc+0x131a>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	9b0080e7          	jalr	-1616(ra) # 53f8 <unlink>
    3a50:	36055d63          	bgez	a0,3dca <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3a54:	00003517          	auipc	a0,0x3
    3a58:	12c50513          	addi	a0,a0,300 # 6b80 <malloc+0x1392>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	9b4080e7          	jalr	-1612(ra) # 5410 <mkdir>
    3a64:	38051163          	bnez	a0,3de6 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3a68:	20200593          	li	a1,514
    3a6c:	00003517          	auipc	a0,0x3
    3a70:	13c50513          	addi	a0,a0,316 # 6ba8 <malloc+0x13ba>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	974080e7          	jalr	-1676(ra) # 53e8 <open>
    3a7c:	84aa                	mv	s1,a0
  if(fd < 0){
    3a7e:	38054263          	bltz	a0,3e02 <subdir+0x42a>
  write(fd, "FF", 2);
    3a82:	4609                	li	a2,2
    3a84:	00003597          	auipc	a1,0x3
    3a88:	15458593          	addi	a1,a1,340 # 6bd8 <malloc+0x13ea>
    3a8c:	00002097          	auipc	ra,0x2
    3a90:	93c080e7          	jalr	-1732(ra) # 53c8 <write>
  close(fd);
    3a94:	8526                	mv	a0,s1
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	93a080e7          	jalr	-1734(ra) # 53d0 <close>
  fd = open("dd/dd/../ff", 0);
    3a9e:	4581                	li	a1,0
    3aa0:	00003517          	auipc	a0,0x3
    3aa4:	14050513          	addi	a0,a0,320 # 6be0 <malloc+0x13f2>
    3aa8:	00002097          	auipc	ra,0x2
    3aac:	940080e7          	jalr	-1728(ra) # 53e8 <open>
    3ab0:	84aa                	mv	s1,a0
  if(fd < 0){
    3ab2:	36054663          	bltz	a0,3e1e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3ab6:	660d                	lui	a2,0x3
    3ab8:	00006597          	auipc	a1,0x6
    3abc:	6f858593          	addi	a1,a1,1784 # a1b0 <buf>
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	900080e7          	jalr	-1792(ra) # 53c0 <read>
  if(cc != 2 || buf[0] != 'f'){
    3ac8:	4789                	li	a5,2
    3aca:	36f51863          	bne	a0,a5,3e3a <subdir+0x462>
    3ace:	00006717          	auipc	a4,0x6
    3ad2:	6e274703          	lbu	a4,1762(a4) # a1b0 <buf>
    3ad6:	06600793          	li	a5,102
    3ada:	36f71063          	bne	a4,a5,3e3a <subdir+0x462>
  close(fd);
    3ade:	8526                	mv	a0,s1
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	8f0080e7          	jalr	-1808(ra) # 53d0 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3ae8:	00003597          	auipc	a1,0x3
    3aec:	14858593          	addi	a1,a1,328 # 6c30 <malloc+0x1442>
    3af0:	00003517          	auipc	a0,0x3
    3af4:	0b850513          	addi	a0,a0,184 # 6ba8 <malloc+0x13ba>
    3af8:	00002097          	auipc	ra,0x2
    3afc:	910080e7          	jalr	-1776(ra) # 5408 <link>
    3b00:	34051b63          	bnez	a0,3e56 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3b04:	00003517          	auipc	a0,0x3
    3b08:	0a450513          	addi	a0,a0,164 # 6ba8 <malloc+0x13ba>
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	8ec080e7          	jalr	-1812(ra) # 53f8 <unlink>
    3b14:	34051f63          	bnez	a0,3e72 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3b18:	4581                	li	a1,0
    3b1a:	00003517          	auipc	a0,0x3
    3b1e:	08e50513          	addi	a0,a0,142 # 6ba8 <malloc+0x13ba>
    3b22:	00002097          	auipc	ra,0x2
    3b26:	8c6080e7          	jalr	-1850(ra) # 53e8 <open>
    3b2a:	36055263          	bgez	a0,3e8e <subdir+0x4b6>
  if(chdir("dd") != 0){
    3b2e:	00003517          	auipc	a0,0x3
    3b32:	fda50513          	addi	a0,a0,-38 # 6b08 <malloc+0x131a>
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	8e2080e7          	jalr	-1822(ra) # 5418 <chdir>
    3b3e:	36051663          	bnez	a0,3eaa <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3b42:	00003517          	auipc	a0,0x3
    3b46:	18650513          	addi	a0,a0,390 # 6cc8 <malloc+0x14da>
    3b4a:	00002097          	auipc	ra,0x2
    3b4e:	8ce080e7          	jalr	-1842(ra) # 5418 <chdir>
    3b52:	36051a63          	bnez	a0,3ec6 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3b56:	00003517          	auipc	a0,0x3
    3b5a:	1a250513          	addi	a0,a0,418 # 6cf8 <malloc+0x150a>
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	8ba080e7          	jalr	-1862(ra) # 5418 <chdir>
    3b66:	36051e63          	bnez	a0,3ee2 <subdir+0x50a>
  if(chdir("./..") != 0){
    3b6a:	00003517          	auipc	a0,0x3
    3b6e:	1be50513          	addi	a0,a0,446 # 6d28 <malloc+0x153a>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	8a6080e7          	jalr	-1882(ra) # 5418 <chdir>
    3b7a:	38051263          	bnez	a0,3efe <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3b7e:	4581                	li	a1,0
    3b80:	00003517          	auipc	a0,0x3
    3b84:	0b050513          	addi	a0,a0,176 # 6c30 <malloc+0x1442>
    3b88:	00002097          	auipc	ra,0x2
    3b8c:	860080e7          	jalr	-1952(ra) # 53e8 <open>
    3b90:	84aa                	mv	s1,a0
  if(fd < 0){
    3b92:	38054463          	bltz	a0,3f1a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3b96:	660d                	lui	a2,0x3
    3b98:	00006597          	auipc	a1,0x6
    3b9c:	61858593          	addi	a1,a1,1560 # a1b0 <buf>
    3ba0:	00002097          	auipc	ra,0x2
    3ba4:	820080e7          	jalr	-2016(ra) # 53c0 <read>
    3ba8:	4789                	li	a5,2
    3baa:	38f51663          	bne	a0,a5,3f36 <subdir+0x55e>
  close(fd);
    3bae:	8526                	mv	a0,s1
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	820080e7          	jalr	-2016(ra) # 53d0 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3bb8:	4581                	li	a1,0
    3bba:	00003517          	auipc	a0,0x3
    3bbe:	fee50513          	addi	a0,a0,-18 # 6ba8 <malloc+0x13ba>
    3bc2:	00002097          	auipc	ra,0x2
    3bc6:	826080e7          	jalr	-2010(ra) # 53e8 <open>
    3bca:	38055463          	bgez	a0,3f52 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3bce:	20200593          	li	a1,514
    3bd2:	00003517          	auipc	a0,0x3
    3bd6:	1e650513          	addi	a0,a0,486 # 6db8 <malloc+0x15ca>
    3bda:	00002097          	auipc	ra,0x2
    3bde:	80e080e7          	jalr	-2034(ra) # 53e8 <open>
    3be2:	38055663          	bgez	a0,3f6e <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3be6:	20200593          	li	a1,514
    3bea:	00003517          	auipc	a0,0x3
    3bee:	1fe50513          	addi	a0,a0,510 # 6de8 <malloc+0x15fa>
    3bf2:	00001097          	auipc	ra,0x1
    3bf6:	7f6080e7          	jalr	2038(ra) # 53e8 <open>
    3bfa:	38055863          	bgez	a0,3f8a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3bfe:	20000593          	li	a1,512
    3c02:	00003517          	auipc	a0,0x3
    3c06:	f0650513          	addi	a0,a0,-250 # 6b08 <malloc+0x131a>
    3c0a:	00001097          	auipc	ra,0x1
    3c0e:	7de080e7          	jalr	2014(ra) # 53e8 <open>
    3c12:	38055a63          	bgez	a0,3fa6 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3c16:	4589                	li	a1,2
    3c18:	00003517          	auipc	a0,0x3
    3c1c:	ef050513          	addi	a0,a0,-272 # 6b08 <malloc+0x131a>
    3c20:	00001097          	auipc	ra,0x1
    3c24:	7c8080e7          	jalr	1992(ra) # 53e8 <open>
    3c28:	38055d63          	bgez	a0,3fc2 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3c2c:	4585                	li	a1,1
    3c2e:	00003517          	auipc	a0,0x3
    3c32:	eda50513          	addi	a0,a0,-294 # 6b08 <malloc+0x131a>
    3c36:	00001097          	auipc	ra,0x1
    3c3a:	7b2080e7          	jalr	1970(ra) # 53e8 <open>
    3c3e:	3a055063          	bgez	a0,3fde <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3c42:	00003597          	auipc	a1,0x3
    3c46:	23658593          	addi	a1,a1,566 # 6e78 <malloc+0x168a>
    3c4a:	00003517          	auipc	a0,0x3
    3c4e:	16e50513          	addi	a0,a0,366 # 6db8 <malloc+0x15ca>
    3c52:	00001097          	auipc	ra,0x1
    3c56:	7b6080e7          	jalr	1974(ra) # 5408 <link>
    3c5a:	3a050063          	beqz	a0,3ffa <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3c5e:	00003597          	auipc	a1,0x3
    3c62:	21a58593          	addi	a1,a1,538 # 6e78 <malloc+0x168a>
    3c66:	00003517          	auipc	a0,0x3
    3c6a:	18250513          	addi	a0,a0,386 # 6de8 <malloc+0x15fa>
    3c6e:	00001097          	auipc	ra,0x1
    3c72:	79a080e7          	jalr	1946(ra) # 5408 <link>
    3c76:	3a050063          	beqz	a0,4016 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3c7a:	00003597          	auipc	a1,0x3
    3c7e:	fb658593          	addi	a1,a1,-74 # 6c30 <malloc+0x1442>
    3c82:	00003517          	auipc	a0,0x3
    3c86:	ea650513          	addi	a0,a0,-346 # 6b28 <malloc+0x133a>
    3c8a:	00001097          	auipc	ra,0x1
    3c8e:	77e080e7          	jalr	1918(ra) # 5408 <link>
    3c92:	3a050063          	beqz	a0,4032 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3c96:	00003517          	auipc	a0,0x3
    3c9a:	12250513          	addi	a0,a0,290 # 6db8 <malloc+0x15ca>
    3c9e:	00001097          	auipc	ra,0x1
    3ca2:	772080e7          	jalr	1906(ra) # 5410 <mkdir>
    3ca6:	3a050463          	beqz	a0,404e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3caa:	00003517          	auipc	a0,0x3
    3cae:	13e50513          	addi	a0,a0,318 # 6de8 <malloc+0x15fa>
    3cb2:	00001097          	auipc	ra,0x1
    3cb6:	75e080e7          	jalr	1886(ra) # 5410 <mkdir>
    3cba:	3a050863          	beqz	a0,406a <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3cbe:	00003517          	auipc	a0,0x3
    3cc2:	f7250513          	addi	a0,a0,-142 # 6c30 <malloc+0x1442>
    3cc6:	00001097          	auipc	ra,0x1
    3cca:	74a080e7          	jalr	1866(ra) # 5410 <mkdir>
    3cce:	3a050c63          	beqz	a0,4086 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3cd2:	00003517          	auipc	a0,0x3
    3cd6:	11650513          	addi	a0,a0,278 # 6de8 <malloc+0x15fa>
    3cda:	00001097          	auipc	ra,0x1
    3cde:	71e080e7          	jalr	1822(ra) # 53f8 <unlink>
    3ce2:	3c050063          	beqz	a0,40a2 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3ce6:	00003517          	auipc	a0,0x3
    3cea:	0d250513          	addi	a0,a0,210 # 6db8 <malloc+0x15ca>
    3cee:	00001097          	auipc	ra,0x1
    3cf2:	70a080e7          	jalr	1802(ra) # 53f8 <unlink>
    3cf6:	3c050463          	beqz	a0,40be <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3cfa:	00003517          	auipc	a0,0x3
    3cfe:	e2e50513          	addi	a0,a0,-466 # 6b28 <malloc+0x133a>
    3d02:	00001097          	auipc	ra,0x1
    3d06:	716080e7          	jalr	1814(ra) # 5418 <chdir>
    3d0a:	3c050863          	beqz	a0,40da <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3d0e:	00003517          	auipc	a0,0x3
    3d12:	2ba50513          	addi	a0,a0,698 # 6fc8 <malloc+0x17da>
    3d16:	00001097          	auipc	ra,0x1
    3d1a:	702080e7          	jalr	1794(ra) # 5418 <chdir>
    3d1e:	3c050c63          	beqz	a0,40f6 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3d22:	00003517          	auipc	a0,0x3
    3d26:	f0e50513          	addi	a0,a0,-242 # 6c30 <malloc+0x1442>
    3d2a:	00001097          	auipc	ra,0x1
    3d2e:	6ce080e7          	jalr	1742(ra) # 53f8 <unlink>
    3d32:	3e051063          	bnez	a0,4112 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3d36:	00003517          	auipc	a0,0x3
    3d3a:	df250513          	addi	a0,a0,-526 # 6b28 <malloc+0x133a>
    3d3e:	00001097          	auipc	ra,0x1
    3d42:	6ba080e7          	jalr	1722(ra) # 53f8 <unlink>
    3d46:	3e051463          	bnez	a0,412e <subdir+0x756>
  if(unlink("dd") == 0){
    3d4a:	00003517          	auipc	a0,0x3
    3d4e:	dbe50513          	addi	a0,a0,-578 # 6b08 <malloc+0x131a>
    3d52:	00001097          	auipc	ra,0x1
    3d56:	6a6080e7          	jalr	1702(ra) # 53f8 <unlink>
    3d5a:	3e050863          	beqz	a0,414a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3d5e:	00003517          	auipc	a0,0x3
    3d62:	2da50513          	addi	a0,a0,730 # 7038 <malloc+0x184a>
    3d66:	00001097          	auipc	ra,0x1
    3d6a:	692080e7          	jalr	1682(ra) # 53f8 <unlink>
    3d6e:	3e054c63          	bltz	a0,4166 <subdir+0x78e>
  if(unlink("dd") < 0){
    3d72:	00003517          	auipc	a0,0x3
    3d76:	d9650513          	addi	a0,a0,-618 # 6b08 <malloc+0x131a>
    3d7a:	00001097          	auipc	ra,0x1
    3d7e:	67e080e7          	jalr	1662(ra) # 53f8 <unlink>
    3d82:	40054063          	bltz	a0,4182 <subdir+0x7aa>
}
    3d86:	60e2                	ld	ra,24(sp)
    3d88:	6442                	ld	s0,16(sp)
    3d8a:	64a2                	ld	s1,8(sp)
    3d8c:	6902                	ld	s2,0(sp)
    3d8e:	6105                	addi	sp,sp,32
    3d90:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3d92:	85ca                	mv	a1,s2
    3d94:	00003517          	auipc	a0,0x3
    3d98:	d7c50513          	addi	a0,a0,-644 # 6b10 <malloc+0x1322>
    3d9c:	00002097          	auipc	ra,0x2
    3da0:	994080e7          	jalr	-1644(ra) # 5730 <printf>
    exit(1);
    3da4:	4505                	li	a0,1
    3da6:	00001097          	auipc	ra,0x1
    3daa:	602080e7          	jalr	1538(ra) # 53a8 <exit>
    printf("%s: create dd/ff failed\n", s);
    3dae:	85ca                	mv	a1,s2
    3db0:	00003517          	auipc	a0,0x3
    3db4:	d8050513          	addi	a0,a0,-640 # 6b30 <malloc+0x1342>
    3db8:	00002097          	auipc	ra,0x2
    3dbc:	978080e7          	jalr	-1672(ra) # 5730 <printf>
    exit(1);
    3dc0:	4505                	li	a0,1
    3dc2:	00001097          	auipc	ra,0x1
    3dc6:	5e6080e7          	jalr	1510(ra) # 53a8 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3dca:	85ca                	mv	a1,s2
    3dcc:	00003517          	auipc	a0,0x3
    3dd0:	d8450513          	addi	a0,a0,-636 # 6b50 <malloc+0x1362>
    3dd4:	00002097          	auipc	ra,0x2
    3dd8:	95c080e7          	jalr	-1700(ra) # 5730 <printf>
    exit(1);
    3ddc:	4505                	li	a0,1
    3dde:	00001097          	auipc	ra,0x1
    3de2:	5ca080e7          	jalr	1482(ra) # 53a8 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3de6:	85ca                	mv	a1,s2
    3de8:	00003517          	auipc	a0,0x3
    3dec:	da050513          	addi	a0,a0,-608 # 6b88 <malloc+0x139a>
    3df0:	00002097          	auipc	ra,0x2
    3df4:	940080e7          	jalr	-1728(ra) # 5730 <printf>
    exit(1);
    3df8:	4505                	li	a0,1
    3dfa:	00001097          	auipc	ra,0x1
    3dfe:	5ae080e7          	jalr	1454(ra) # 53a8 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3e02:	85ca                	mv	a1,s2
    3e04:	00003517          	auipc	a0,0x3
    3e08:	db450513          	addi	a0,a0,-588 # 6bb8 <malloc+0x13ca>
    3e0c:	00002097          	auipc	ra,0x2
    3e10:	924080e7          	jalr	-1756(ra) # 5730 <printf>
    exit(1);
    3e14:	4505                	li	a0,1
    3e16:	00001097          	auipc	ra,0x1
    3e1a:	592080e7          	jalr	1426(ra) # 53a8 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3e1e:	85ca                	mv	a1,s2
    3e20:	00003517          	auipc	a0,0x3
    3e24:	dd050513          	addi	a0,a0,-560 # 6bf0 <malloc+0x1402>
    3e28:	00002097          	auipc	ra,0x2
    3e2c:	908080e7          	jalr	-1784(ra) # 5730 <printf>
    exit(1);
    3e30:	4505                	li	a0,1
    3e32:	00001097          	auipc	ra,0x1
    3e36:	576080e7          	jalr	1398(ra) # 53a8 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3e3a:	85ca                	mv	a1,s2
    3e3c:	00003517          	auipc	a0,0x3
    3e40:	dd450513          	addi	a0,a0,-556 # 6c10 <malloc+0x1422>
    3e44:	00002097          	auipc	ra,0x2
    3e48:	8ec080e7          	jalr	-1812(ra) # 5730 <printf>
    exit(1);
    3e4c:	4505                	li	a0,1
    3e4e:	00001097          	auipc	ra,0x1
    3e52:	55a080e7          	jalr	1370(ra) # 53a8 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3e56:	85ca                	mv	a1,s2
    3e58:	00003517          	auipc	a0,0x3
    3e5c:	de850513          	addi	a0,a0,-536 # 6c40 <malloc+0x1452>
    3e60:	00002097          	auipc	ra,0x2
    3e64:	8d0080e7          	jalr	-1840(ra) # 5730 <printf>
    exit(1);
    3e68:	4505                	li	a0,1
    3e6a:	00001097          	auipc	ra,0x1
    3e6e:	53e080e7          	jalr	1342(ra) # 53a8 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3e72:	85ca                	mv	a1,s2
    3e74:	00003517          	auipc	a0,0x3
    3e78:	df450513          	addi	a0,a0,-524 # 6c68 <malloc+0x147a>
    3e7c:	00002097          	auipc	ra,0x2
    3e80:	8b4080e7          	jalr	-1868(ra) # 5730 <printf>
    exit(1);
    3e84:	4505                	li	a0,1
    3e86:	00001097          	auipc	ra,0x1
    3e8a:	522080e7          	jalr	1314(ra) # 53a8 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3e8e:	85ca                	mv	a1,s2
    3e90:	00003517          	auipc	a0,0x3
    3e94:	df850513          	addi	a0,a0,-520 # 6c88 <malloc+0x149a>
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	898080e7          	jalr	-1896(ra) # 5730 <printf>
    exit(1);
    3ea0:	4505                	li	a0,1
    3ea2:	00001097          	auipc	ra,0x1
    3ea6:	506080e7          	jalr	1286(ra) # 53a8 <exit>
    printf("%s: chdir dd failed\n", s);
    3eaa:	85ca                	mv	a1,s2
    3eac:	00003517          	auipc	a0,0x3
    3eb0:	e0450513          	addi	a0,a0,-508 # 6cb0 <malloc+0x14c2>
    3eb4:	00002097          	auipc	ra,0x2
    3eb8:	87c080e7          	jalr	-1924(ra) # 5730 <printf>
    exit(1);
    3ebc:	4505                	li	a0,1
    3ebe:	00001097          	auipc	ra,0x1
    3ec2:	4ea080e7          	jalr	1258(ra) # 53a8 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3ec6:	85ca                	mv	a1,s2
    3ec8:	00003517          	auipc	a0,0x3
    3ecc:	e1050513          	addi	a0,a0,-496 # 6cd8 <malloc+0x14ea>
    3ed0:	00002097          	auipc	ra,0x2
    3ed4:	860080e7          	jalr	-1952(ra) # 5730 <printf>
    exit(1);
    3ed8:	4505                	li	a0,1
    3eda:	00001097          	auipc	ra,0x1
    3ede:	4ce080e7          	jalr	1230(ra) # 53a8 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3ee2:	85ca                	mv	a1,s2
    3ee4:	00003517          	auipc	a0,0x3
    3ee8:	e2450513          	addi	a0,a0,-476 # 6d08 <malloc+0x151a>
    3eec:	00002097          	auipc	ra,0x2
    3ef0:	844080e7          	jalr	-1980(ra) # 5730 <printf>
    exit(1);
    3ef4:	4505                	li	a0,1
    3ef6:	00001097          	auipc	ra,0x1
    3efa:	4b2080e7          	jalr	1202(ra) # 53a8 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3efe:	85ca                	mv	a1,s2
    3f00:	00003517          	auipc	a0,0x3
    3f04:	e3050513          	addi	a0,a0,-464 # 6d30 <malloc+0x1542>
    3f08:	00002097          	auipc	ra,0x2
    3f0c:	828080e7          	jalr	-2008(ra) # 5730 <printf>
    exit(1);
    3f10:	4505                	li	a0,1
    3f12:	00001097          	auipc	ra,0x1
    3f16:	496080e7          	jalr	1174(ra) # 53a8 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3f1a:	85ca                	mv	a1,s2
    3f1c:	00003517          	auipc	a0,0x3
    3f20:	e2c50513          	addi	a0,a0,-468 # 6d48 <malloc+0x155a>
    3f24:	00002097          	auipc	ra,0x2
    3f28:	80c080e7          	jalr	-2036(ra) # 5730 <printf>
    exit(1);
    3f2c:	4505                	li	a0,1
    3f2e:	00001097          	auipc	ra,0x1
    3f32:	47a080e7          	jalr	1146(ra) # 53a8 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3f36:	85ca                	mv	a1,s2
    3f38:	00003517          	auipc	a0,0x3
    3f3c:	e3050513          	addi	a0,a0,-464 # 6d68 <malloc+0x157a>
    3f40:	00001097          	auipc	ra,0x1
    3f44:	7f0080e7          	jalr	2032(ra) # 5730 <printf>
    exit(1);
    3f48:	4505                	li	a0,1
    3f4a:	00001097          	auipc	ra,0x1
    3f4e:	45e080e7          	jalr	1118(ra) # 53a8 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3f52:	85ca                	mv	a1,s2
    3f54:	00003517          	auipc	a0,0x3
    3f58:	e3450513          	addi	a0,a0,-460 # 6d88 <malloc+0x159a>
    3f5c:	00001097          	auipc	ra,0x1
    3f60:	7d4080e7          	jalr	2004(ra) # 5730 <printf>
    exit(1);
    3f64:	4505                	li	a0,1
    3f66:	00001097          	auipc	ra,0x1
    3f6a:	442080e7          	jalr	1090(ra) # 53a8 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3f6e:	85ca                	mv	a1,s2
    3f70:	00003517          	auipc	a0,0x3
    3f74:	e5850513          	addi	a0,a0,-424 # 6dc8 <malloc+0x15da>
    3f78:	00001097          	auipc	ra,0x1
    3f7c:	7b8080e7          	jalr	1976(ra) # 5730 <printf>
    exit(1);
    3f80:	4505                	li	a0,1
    3f82:	00001097          	auipc	ra,0x1
    3f86:	426080e7          	jalr	1062(ra) # 53a8 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3f8a:	85ca                	mv	a1,s2
    3f8c:	00003517          	auipc	a0,0x3
    3f90:	e6c50513          	addi	a0,a0,-404 # 6df8 <malloc+0x160a>
    3f94:	00001097          	auipc	ra,0x1
    3f98:	79c080e7          	jalr	1948(ra) # 5730 <printf>
    exit(1);
    3f9c:	4505                	li	a0,1
    3f9e:	00001097          	auipc	ra,0x1
    3fa2:	40a080e7          	jalr	1034(ra) # 53a8 <exit>
    printf("%s: create dd succeeded!\n", s);
    3fa6:	85ca                	mv	a1,s2
    3fa8:	00003517          	auipc	a0,0x3
    3fac:	e7050513          	addi	a0,a0,-400 # 6e18 <malloc+0x162a>
    3fb0:	00001097          	auipc	ra,0x1
    3fb4:	780080e7          	jalr	1920(ra) # 5730 <printf>
    exit(1);
    3fb8:	4505                	li	a0,1
    3fba:	00001097          	auipc	ra,0x1
    3fbe:	3ee080e7          	jalr	1006(ra) # 53a8 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3fc2:	85ca                	mv	a1,s2
    3fc4:	00003517          	auipc	a0,0x3
    3fc8:	e7450513          	addi	a0,a0,-396 # 6e38 <malloc+0x164a>
    3fcc:	00001097          	auipc	ra,0x1
    3fd0:	764080e7          	jalr	1892(ra) # 5730 <printf>
    exit(1);
    3fd4:	4505                	li	a0,1
    3fd6:	00001097          	auipc	ra,0x1
    3fda:	3d2080e7          	jalr	978(ra) # 53a8 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3fde:	85ca                	mv	a1,s2
    3fe0:	00003517          	auipc	a0,0x3
    3fe4:	e7850513          	addi	a0,a0,-392 # 6e58 <malloc+0x166a>
    3fe8:	00001097          	auipc	ra,0x1
    3fec:	748080e7          	jalr	1864(ra) # 5730 <printf>
    exit(1);
    3ff0:	4505                	li	a0,1
    3ff2:	00001097          	auipc	ra,0x1
    3ff6:	3b6080e7          	jalr	950(ra) # 53a8 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3ffa:	85ca                	mv	a1,s2
    3ffc:	00003517          	auipc	a0,0x3
    4000:	e8c50513          	addi	a0,a0,-372 # 6e88 <malloc+0x169a>
    4004:	00001097          	auipc	ra,0x1
    4008:	72c080e7          	jalr	1836(ra) # 5730 <printf>
    exit(1);
    400c:	4505                	li	a0,1
    400e:	00001097          	auipc	ra,0x1
    4012:	39a080e7          	jalr	922(ra) # 53a8 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    4016:	85ca                	mv	a1,s2
    4018:	00003517          	auipc	a0,0x3
    401c:	e9850513          	addi	a0,a0,-360 # 6eb0 <malloc+0x16c2>
    4020:	00001097          	auipc	ra,0x1
    4024:	710080e7          	jalr	1808(ra) # 5730 <printf>
    exit(1);
    4028:	4505                	li	a0,1
    402a:	00001097          	auipc	ra,0x1
    402e:	37e080e7          	jalr	894(ra) # 53a8 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    4032:	85ca                	mv	a1,s2
    4034:	00003517          	auipc	a0,0x3
    4038:	ea450513          	addi	a0,a0,-348 # 6ed8 <malloc+0x16ea>
    403c:	00001097          	auipc	ra,0x1
    4040:	6f4080e7          	jalr	1780(ra) # 5730 <printf>
    exit(1);
    4044:	4505                	li	a0,1
    4046:	00001097          	auipc	ra,0x1
    404a:	362080e7          	jalr	866(ra) # 53a8 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    404e:	85ca                	mv	a1,s2
    4050:	00003517          	auipc	a0,0x3
    4054:	eb050513          	addi	a0,a0,-336 # 6f00 <malloc+0x1712>
    4058:	00001097          	auipc	ra,0x1
    405c:	6d8080e7          	jalr	1752(ra) # 5730 <printf>
    exit(1);
    4060:	4505                	li	a0,1
    4062:	00001097          	auipc	ra,0x1
    4066:	346080e7          	jalr	838(ra) # 53a8 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    406a:	85ca                	mv	a1,s2
    406c:	00003517          	auipc	a0,0x3
    4070:	eb450513          	addi	a0,a0,-332 # 6f20 <malloc+0x1732>
    4074:	00001097          	auipc	ra,0x1
    4078:	6bc080e7          	jalr	1724(ra) # 5730 <printf>
    exit(1);
    407c:	4505                	li	a0,1
    407e:	00001097          	auipc	ra,0x1
    4082:	32a080e7          	jalr	810(ra) # 53a8 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    4086:	85ca                	mv	a1,s2
    4088:	00003517          	auipc	a0,0x3
    408c:	eb850513          	addi	a0,a0,-328 # 6f40 <malloc+0x1752>
    4090:	00001097          	auipc	ra,0x1
    4094:	6a0080e7          	jalr	1696(ra) # 5730 <printf>
    exit(1);
    4098:	4505                	li	a0,1
    409a:	00001097          	auipc	ra,0x1
    409e:	30e080e7          	jalr	782(ra) # 53a8 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    40a2:	85ca                	mv	a1,s2
    40a4:	00003517          	auipc	a0,0x3
    40a8:	ec450513          	addi	a0,a0,-316 # 6f68 <malloc+0x177a>
    40ac:	00001097          	auipc	ra,0x1
    40b0:	684080e7          	jalr	1668(ra) # 5730 <printf>
    exit(1);
    40b4:	4505                	li	a0,1
    40b6:	00001097          	auipc	ra,0x1
    40ba:	2f2080e7          	jalr	754(ra) # 53a8 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    40be:	85ca                	mv	a1,s2
    40c0:	00003517          	auipc	a0,0x3
    40c4:	ec850513          	addi	a0,a0,-312 # 6f88 <malloc+0x179a>
    40c8:	00001097          	auipc	ra,0x1
    40cc:	668080e7          	jalr	1640(ra) # 5730 <printf>
    exit(1);
    40d0:	4505                	li	a0,1
    40d2:	00001097          	auipc	ra,0x1
    40d6:	2d6080e7          	jalr	726(ra) # 53a8 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    40da:	85ca                	mv	a1,s2
    40dc:	00003517          	auipc	a0,0x3
    40e0:	ecc50513          	addi	a0,a0,-308 # 6fa8 <malloc+0x17ba>
    40e4:	00001097          	auipc	ra,0x1
    40e8:	64c080e7          	jalr	1612(ra) # 5730 <printf>
    exit(1);
    40ec:	4505                	li	a0,1
    40ee:	00001097          	auipc	ra,0x1
    40f2:	2ba080e7          	jalr	698(ra) # 53a8 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    40f6:	85ca                	mv	a1,s2
    40f8:	00003517          	auipc	a0,0x3
    40fc:	ed850513          	addi	a0,a0,-296 # 6fd0 <malloc+0x17e2>
    4100:	00001097          	auipc	ra,0x1
    4104:	630080e7          	jalr	1584(ra) # 5730 <printf>
    exit(1);
    4108:	4505                	li	a0,1
    410a:	00001097          	auipc	ra,0x1
    410e:	29e080e7          	jalr	670(ra) # 53a8 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    4112:	85ca                	mv	a1,s2
    4114:	00003517          	auipc	a0,0x3
    4118:	b5450513          	addi	a0,a0,-1196 # 6c68 <malloc+0x147a>
    411c:	00001097          	auipc	ra,0x1
    4120:	614080e7          	jalr	1556(ra) # 5730 <printf>
    exit(1);
    4124:	4505                	li	a0,1
    4126:	00001097          	auipc	ra,0x1
    412a:	282080e7          	jalr	642(ra) # 53a8 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    412e:	85ca                	mv	a1,s2
    4130:	00003517          	auipc	a0,0x3
    4134:	ec050513          	addi	a0,a0,-320 # 6ff0 <malloc+0x1802>
    4138:	00001097          	auipc	ra,0x1
    413c:	5f8080e7          	jalr	1528(ra) # 5730 <printf>
    exit(1);
    4140:	4505                	li	a0,1
    4142:	00001097          	auipc	ra,0x1
    4146:	266080e7          	jalr	614(ra) # 53a8 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    414a:	85ca                	mv	a1,s2
    414c:	00003517          	auipc	a0,0x3
    4150:	ec450513          	addi	a0,a0,-316 # 7010 <malloc+0x1822>
    4154:	00001097          	auipc	ra,0x1
    4158:	5dc080e7          	jalr	1500(ra) # 5730 <printf>
    exit(1);
    415c:	4505                	li	a0,1
    415e:	00001097          	auipc	ra,0x1
    4162:	24a080e7          	jalr	586(ra) # 53a8 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    4166:	85ca                	mv	a1,s2
    4168:	00003517          	auipc	a0,0x3
    416c:	ed850513          	addi	a0,a0,-296 # 7040 <malloc+0x1852>
    4170:	00001097          	auipc	ra,0x1
    4174:	5c0080e7          	jalr	1472(ra) # 5730 <printf>
    exit(1);
    4178:	4505                	li	a0,1
    417a:	00001097          	auipc	ra,0x1
    417e:	22e080e7          	jalr	558(ra) # 53a8 <exit>
    printf("%s: unlink dd failed\n", s);
    4182:	85ca                	mv	a1,s2
    4184:	00003517          	auipc	a0,0x3
    4188:	edc50513          	addi	a0,a0,-292 # 7060 <malloc+0x1872>
    418c:	00001097          	auipc	ra,0x1
    4190:	5a4080e7          	jalr	1444(ra) # 5730 <printf>
    exit(1);
    4194:	4505                	li	a0,1
    4196:	00001097          	auipc	ra,0x1
    419a:	212080e7          	jalr	530(ra) # 53a8 <exit>

000000000000419e <dirfile>:
{
    419e:	1101                	addi	sp,sp,-32
    41a0:	ec06                	sd	ra,24(sp)
    41a2:	e822                	sd	s0,16(sp)
    41a4:	e426                	sd	s1,8(sp)
    41a6:	e04a                	sd	s2,0(sp)
    41a8:	1000                	addi	s0,sp,32
    41aa:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    41ac:	20000593          	li	a1,512
    41b0:	00002517          	auipc	a0,0x2
    41b4:	98850513          	addi	a0,a0,-1656 # 5b38 <malloc+0x34a>
    41b8:	00001097          	auipc	ra,0x1
    41bc:	230080e7          	jalr	560(ra) # 53e8 <open>
  if(fd < 0){
    41c0:	0e054d63          	bltz	a0,42ba <dirfile+0x11c>
  close(fd);
    41c4:	00001097          	auipc	ra,0x1
    41c8:	20c080e7          	jalr	524(ra) # 53d0 <close>
  if(chdir("dirfile") == 0){
    41cc:	00002517          	auipc	a0,0x2
    41d0:	96c50513          	addi	a0,a0,-1684 # 5b38 <malloc+0x34a>
    41d4:	00001097          	auipc	ra,0x1
    41d8:	244080e7          	jalr	580(ra) # 5418 <chdir>
    41dc:	cd6d                	beqz	a0,42d6 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    41de:	4581                	li	a1,0
    41e0:	00003517          	auipc	a0,0x3
    41e4:	ed850513          	addi	a0,a0,-296 # 70b8 <malloc+0x18ca>
    41e8:	00001097          	auipc	ra,0x1
    41ec:	200080e7          	jalr	512(ra) # 53e8 <open>
  if(fd >= 0){
    41f0:	10055163          	bgez	a0,42f2 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    41f4:	20000593          	li	a1,512
    41f8:	00003517          	auipc	a0,0x3
    41fc:	ec050513          	addi	a0,a0,-320 # 70b8 <malloc+0x18ca>
    4200:	00001097          	auipc	ra,0x1
    4204:	1e8080e7          	jalr	488(ra) # 53e8 <open>
  if(fd >= 0){
    4208:	10055363          	bgez	a0,430e <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    420c:	00003517          	auipc	a0,0x3
    4210:	eac50513          	addi	a0,a0,-340 # 70b8 <malloc+0x18ca>
    4214:	00001097          	auipc	ra,0x1
    4218:	1fc080e7          	jalr	508(ra) # 5410 <mkdir>
    421c:	10050763          	beqz	a0,432a <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4220:	00003517          	auipc	a0,0x3
    4224:	e9850513          	addi	a0,a0,-360 # 70b8 <malloc+0x18ca>
    4228:	00001097          	auipc	ra,0x1
    422c:	1d0080e7          	jalr	464(ra) # 53f8 <unlink>
    4230:	10050b63          	beqz	a0,4346 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    4234:	00003597          	auipc	a1,0x3
    4238:	e8458593          	addi	a1,a1,-380 # 70b8 <malloc+0x18ca>
    423c:	00003517          	auipc	a0,0x3
    4240:	f0450513          	addi	a0,a0,-252 # 7140 <malloc+0x1952>
    4244:	00001097          	auipc	ra,0x1
    4248:	1c4080e7          	jalr	452(ra) # 5408 <link>
    424c:	10050b63          	beqz	a0,4362 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    4250:	00002517          	auipc	a0,0x2
    4254:	8e850513          	addi	a0,a0,-1816 # 5b38 <malloc+0x34a>
    4258:	00001097          	auipc	ra,0x1
    425c:	1a0080e7          	jalr	416(ra) # 53f8 <unlink>
    4260:	10051f63          	bnez	a0,437e <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    4264:	4589                	li	a1,2
    4266:	00002517          	auipc	a0,0x2
    426a:	9da50513          	addi	a0,a0,-1574 # 5c40 <malloc+0x452>
    426e:	00001097          	auipc	ra,0x1
    4272:	17a080e7          	jalr	378(ra) # 53e8 <open>
  if(fd >= 0){
    4276:	12055263          	bgez	a0,439a <dirfile+0x1fc>
  fd = open(".", 0);
    427a:	4581                	li	a1,0
    427c:	00002517          	auipc	a0,0x2
    4280:	9c450513          	addi	a0,a0,-1596 # 5c40 <malloc+0x452>
    4284:	00001097          	auipc	ra,0x1
    4288:	164080e7          	jalr	356(ra) # 53e8 <open>
    428c:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    428e:	4605                	li	a2,1
    4290:	00002597          	auipc	a1,0x2
    4294:	41058593          	addi	a1,a1,1040 # 66a0 <malloc+0xeb2>
    4298:	00001097          	auipc	ra,0x1
    429c:	130080e7          	jalr	304(ra) # 53c8 <write>
    42a0:	10a04b63          	bgtz	a0,43b6 <dirfile+0x218>
  close(fd);
    42a4:	8526                	mv	a0,s1
    42a6:	00001097          	auipc	ra,0x1
    42aa:	12a080e7          	jalr	298(ra) # 53d0 <close>
}
    42ae:	60e2                	ld	ra,24(sp)
    42b0:	6442                	ld	s0,16(sp)
    42b2:	64a2                	ld	s1,8(sp)
    42b4:	6902                	ld	s2,0(sp)
    42b6:	6105                	addi	sp,sp,32
    42b8:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    42ba:	85ca                	mv	a1,s2
    42bc:	00003517          	auipc	a0,0x3
    42c0:	dbc50513          	addi	a0,a0,-580 # 7078 <malloc+0x188a>
    42c4:	00001097          	auipc	ra,0x1
    42c8:	46c080e7          	jalr	1132(ra) # 5730 <printf>
    exit(1);
    42cc:	4505                	li	a0,1
    42ce:	00001097          	auipc	ra,0x1
    42d2:	0da080e7          	jalr	218(ra) # 53a8 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    42d6:	85ca                	mv	a1,s2
    42d8:	00003517          	auipc	a0,0x3
    42dc:	dc050513          	addi	a0,a0,-576 # 7098 <malloc+0x18aa>
    42e0:	00001097          	auipc	ra,0x1
    42e4:	450080e7          	jalr	1104(ra) # 5730 <printf>
    exit(1);
    42e8:	4505                	li	a0,1
    42ea:	00001097          	auipc	ra,0x1
    42ee:	0be080e7          	jalr	190(ra) # 53a8 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    42f2:	85ca                	mv	a1,s2
    42f4:	00003517          	auipc	a0,0x3
    42f8:	dd450513          	addi	a0,a0,-556 # 70c8 <malloc+0x18da>
    42fc:	00001097          	auipc	ra,0x1
    4300:	434080e7          	jalr	1076(ra) # 5730 <printf>
    exit(1);
    4304:	4505                	li	a0,1
    4306:	00001097          	auipc	ra,0x1
    430a:	0a2080e7          	jalr	162(ra) # 53a8 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    430e:	85ca                	mv	a1,s2
    4310:	00003517          	auipc	a0,0x3
    4314:	db850513          	addi	a0,a0,-584 # 70c8 <malloc+0x18da>
    4318:	00001097          	auipc	ra,0x1
    431c:	418080e7          	jalr	1048(ra) # 5730 <printf>
    exit(1);
    4320:	4505                	li	a0,1
    4322:	00001097          	auipc	ra,0x1
    4326:	086080e7          	jalr	134(ra) # 53a8 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    432a:	85ca                	mv	a1,s2
    432c:	00003517          	auipc	a0,0x3
    4330:	dc450513          	addi	a0,a0,-572 # 70f0 <malloc+0x1902>
    4334:	00001097          	auipc	ra,0x1
    4338:	3fc080e7          	jalr	1020(ra) # 5730 <printf>
    exit(1);
    433c:	4505                	li	a0,1
    433e:	00001097          	auipc	ra,0x1
    4342:	06a080e7          	jalr	106(ra) # 53a8 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4346:	85ca                	mv	a1,s2
    4348:	00003517          	auipc	a0,0x3
    434c:	dd050513          	addi	a0,a0,-560 # 7118 <malloc+0x192a>
    4350:	00001097          	auipc	ra,0x1
    4354:	3e0080e7          	jalr	992(ra) # 5730 <printf>
    exit(1);
    4358:	4505                	li	a0,1
    435a:	00001097          	auipc	ra,0x1
    435e:	04e080e7          	jalr	78(ra) # 53a8 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4362:	85ca                	mv	a1,s2
    4364:	00003517          	auipc	a0,0x3
    4368:	de450513          	addi	a0,a0,-540 # 7148 <malloc+0x195a>
    436c:	00001097          	auipc	ra,0x1
    4370:	3c4080e7          	jalr	964(ra) # 5730 <printf>
    exit(1);
    4374:	4505                	li	a0,1
    4376:	00001097          	auipc	ra,0x1
    437a:	032080e7          	jalr	50(ra) # 53a8 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    437e:	85ca                	mv	a1,s2
    4380:	00003517          	auipc	a0,0x3
    4384:	df050513          	addi	a0,a0,-528 # 7170 <malloc+0x1982>
    4388:	00001097          	auipc	ra,0x1
    438c:	3a8080e7          	jalr	936(ra) # 5730 <printf>
    exit(1);
    4390:	4505                	li	a0,1
    4392:	00001097          	auipc	ra,0x1
    4396:	016080e7          	jalr	22(ra) # 53a8 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    439a:	85ca                	mv	a1,s2
    439c:	00003517          	auipc	a0,0x3
    43a0:	df450513          	addi	a0,a0,-524 # 7190 <malloc+0x19a2>
    43a4:	00001097          	auipc	ra,0x1
    43a8:	38c080e7          	jalr	908(ra) # 5730 <printf>
    exit(1);
    43ac:	4505                	li	a0,1
    43ae:	00001097          	auipc	ra,0x1
    43b2:	ffa080e7          	jalr	-6(ra) # 53a8 <exit>
    printf("%s: write . succeeded!\n", s);
    43b6:	85ca                	mv	a1,s2
    43b8:	00003517          	auipc	a0,0x3
    43bc:	e0050513          	addi	a0,a0,-512 # 71b8 <malloc+0x19ca>
    43c0:	00001097          	auipc	ra,0x1
    43c4:	370080e7          	jalr	880(ra) # 5730 <printf>
    exit(1);
    43c8:	4505                	li	a0,1
    43ca:	00001097          	auipc	ra,0x1
    43ce:	fde080e7          	jalr	-34(ra) # 53a8 <exit>

00000000000043d2 <iref>:
{
    43d2:	7139                	addi	sp,sp,-64
    43d4:	fc06                	sd	ra,56(sp)
    43d6:	f822                	sd	s0,48(sp)
    43d8:	f426                	sd	s1,40(sp)
    43da:	f04a                	sd	s2,32(sp)
    43dc:	ec4e                	sd	s3,24(sp)
    43de:	e852                	sd	s4,16(sp)
    43e0:	e456                	sd	s5,8(sp)
    43e2:	e05a                	sd	s6,0(sp)
    43e4:	0080                	addi	s0,sp,64
    43e6:	8b2a                	mv	s6,a0
    43e8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    43ec:	00003a17          	auipc	s4,0x3
    43f0:	de4a0a13          	addi	s4,s4,-540 # 71d0 <malloc+0x19e2>
    mkdir("");
    43f4:	00003497          	auipc	s1,0x3
    43f8:	9bc48493          	addi	s1,s1,-1604 # 6db0 <malloc+0x15c2>
    link("README", "");
    43fc:	00003a97          	auipc	s5,0x3
    4400:	d44a8a93          	addi	s5,s5,-700 # 7140 <malloc+0x1952>
    fd = open("xx", O_CREATE);
    4404:	00003997          	auipc	s3,0x3
    4408:	cbc98993          	addi	s3,s3,-836 # 70c0 <malloc+0x18d2>
    440c:	a891                	j	4460 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    440e:	85da                	mv	a1,s6
    4410:	00003517          	auipc	a0,0x3
    4414:	dc850513          	addi	a0,a0,-568 # 71d8 <malloc+0x19ea>
    4418:	00001097          	auipc	ra,0x1
    441c:	318080e7          	jalr	792(ra) # 5730 <printf>
      exit(1);
    4420:	4505                	li	a0,1
    4422:	00001097          	auipc	ra,0x1
    4426:	f86080e7          	jalr	-122(ra) # 53a8 <exit>
      printf("%s: chdir irefd failed\n", s);
    442a:	85da                	mv	a1,s6
    442c:	00003517          	auipc	a0,0x3
    4430:	dc450513          	addi	a0,a0,-572 # 71f0 <malloc+0x1a02>
    4434:	00001097          	auipc	ra,0x1
    4438:	2fc080e7          	jalr	764(ra) # 5730 <printf>
      exit(1);
    443c:	4505                	li	a0,1
    443e:	00001097          	auipc	ra,0x1
    4442:	f6a080e7          	jalr	-150(ra) # 53a8 <exit>
      close(fd);
    4446:	00001097          	auipc	ra,0x1
    444a:	f8a080e7          	jalr	-118(ra) # 53d0 <close>
    444e:	a889                	j	44a0 <iref+0xce>
    unlink("xx");
    4450:	854e                	mv	a0,s3
    4452:	00001097          	auipc	ra,0x1
    4456:	fa6080e7          	jalr	-90(ra) # 53f8 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    445a:	397d                	addiw	s2,s2,-1
    445c:	06090063          	beqz	s2,44bc <iref+0xea>
    if(mkdir("irefd") != 0){
    4460:	8552                	mv	a0,s4
    4462:	00001097          	auipc	ra,0x1
    4466:	fae080e7          	jalr	-82(ra) # 5410 <mkdir>
    446a:	f155                	bnez	a0,440e <iref+0x3c>
    if(chdir("irefd") != 0){
    446c:	8552                	mv	a0,s4
    446e:	00001097          	auipc	ra,0x1
    4472:	faa080e7          	jalr	-86(ra) # 5418 <chdir>
    4476:	f955                	bnez	a0,442a <iref+0x58>
    mkdir("");
    4478:	8526                	mv	a0,s1
    447a:	00001097          	auipc	ra,0x1
    447e:	f96080e7          	jalr	-106(ra) # 5410 <mkdir>
    link("README", "");
    4482:	85a6                	mv	a1,s1
    4484:	8556                	mv	a0,s5
    4486:	00001097          	auipc	ra,0x1
    448a:	f82080e7          	jalr	-126(ra) # 5408 <link>
    fd = open("", O_CREATE);
    448e:	20000593          	li	a1,512
    4492:	8526                	mv	a0,s1
    4494:	00001097          	auipc	ra,0x1
    4498:	f54080e7          	jalr	-172(ra) # 53e8 <open>
    if(fd >= 0)
    449c:	fa0555e3          	bgez	a0,4446 <iref+0x74>
    fd = open("xx", O_CREATE);
    44a0:	20000593          	li	a1,512
    44a4:	854e                	mv	a0,s3
    44a6:	00001097          	auipc	ra,0x1
    44aa:	f42080e7          	jalr	-190(ra) # 53e8 <open>
    if(fd >= 0)
    44ae:	fa0541e3          	bltz	a0,4450 <iref+0x7e>
      close(fd);
    44b2:	00001097          	auipc	ra,0x1
    44b6:	f1e080e7          	jalr	-226(ra) # 53d0 <close>
    44ba:	bf59                	j	4450 <iref+0x7e>
  chdir("/");
    44bc:	00001517          	auipc	a0,0x1
    44c0:	72c50513          	addi	a0,a0,1836 # 5be8 <malloc+0x3fa>
    44c4:	00001097          	auipc	ra,0x1
    44c8:	f54080e7          	jalr	-172(ra) # 5418 <chdir>
}
    44cc:	70e2                	ld	ra,56(sp)
    44ce:	7442                	ld	s0,48(sp)
    44d0:	74a2                	ld	s1,40(sp)
    44d2:	7902                	ld	s2,32(sp)
    44d4:	69e2                	ld	s3,24(sp)
    44d6:	6a42                	ld	s4,16(sp)
    44d8:	6aa2                	ld	s5,8(sp)
    44da:	6b02                	ld	s6,0(sp)
    44dc:	6121                	addi	sp,sp,64
    44de:	8082                	ret

00000000000044e0 <validatetest>:
{
    44e0:	7139                	addi	sp,sp,-64
    44e2:	fc06                	sd	ra,56(sp)
    44e4:	f822                	sd	s0,48(sp)
    44e6:	f426                	sd	s1,40(sp)
    44e8:	f04a                	sd	s2,32(sp)
    44ea:	ec4e                	sd	s3,24(sp)
    44ec:	e852                	sd	s4,16(sp)
    44ee:	e456                	sd	s5,8(sp)
    44f0:	e05a                	sd	s6,0(sp)
    44f2:	0080                	addi	s0,sp,64
    44f4:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    44f6:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    44f8:	00003997          	auipc	s3,0x3
    44fc:	d1098993          	addi	s3,s3,-752 # 7208 <malloc+0x1a1a>
    4500:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    4502:	6a85                	lui	s5,0x1
    4504:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    4508:	85a6                	mv	a1,s1
    450a:	854e                	mv	a0,s3
    450c:	00001097          	auipc	ra,0x1
    4510:	efc080e7          	jalr	-260(ra) # 5408 <link>
    4514:	01251f63          	bne	a0,s2,4532 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    4518:	94d6                	add	s1,s1,s5
    451a:	ff4497e3          	bne	s1,s4,4508 <validatetest+0x28>
}
    451e:	70e2                	ld	ra,56(sp)
    4520:	7442                	ld	s0,48(sp)
    4522:	74a2                	ld	s1,40(sp)
    4524:	7902                	ld	s2,32(sp)
    4526:	69e2                	ld	s3,24(sp)
    4528:	6a42                	ld	s4,16(sp)
    452a:	6aa2                	ld	s5,8(sp)
    452c:	6b02                	ld	s6,0(sp)
    452e:	6121                	addi	sp,sp,64
    4530:	8082                	ret
      printf("%s: link should not succeed\n", s);
    4532:	85da                	mv	a1,s6
    4534:	00003517          	auipc	a0,0x3
    4538:	ce450513          	addi	a0,a0,-796 # 7218 <malloc+0x1a2a>
    453c:	00001097          	auipc	ra,0x1
    4540:	1f4080e7          	jalr	500(ra) # 5730 <printf>
      exit(1);
    4544:	4505                	li	a0,1
    4546:	00001097          	auipc	ra,0x1
    454a:	e62080e7          	jalr	-414(ra) # 53a8 <exit>

000000000000454e <sbrkbasic>:
{
    454e:	7139                	addi	sp,sp,-64
    4550:	fc06                	sd	ra,56(sp)
    4552:	f822                	sd	s0,48(sp)
    4554:	f426                	sd	s1,40(sp)
    4556:	f04a                	sd	s2,32(sp)
    4558:	ec4e                	sd	s3,24(sp)
    455a:	e852                	sd	s4,16(sp)
    455c:	0080                	addi	s0,sp,64
    455e:	8a2a                	mv	s4,a0
  a = sbrk(TOOMUCH);
    4560:	40000537          	lui	a0,0x40000
    4564:	00001097          	auipc	ra,0x1
    4568:	ecc080e7          	jalr	-308(ra) # 5430 <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    456c:	57fd                	li	a5,-1
    456e:	02f50063          	beq	a0,a5,458e <sbrkbasic+0x40>
    4572:	85aa                	mv	a1,a0
    printf("%s: sbrk(<toomuch>) returned %p\n", a);
    4574:	00003517          	auipc	a0,0x3
    4578:	cc450513          	addi	a0,a0,-828 # 7238 <malloc+0x1a4a>
    457c:	00001097          	auipc	ra,0x1
    4580:	1b4080e7          	jalr	436(ra) # 5730 <printf>
    exit(1);
    4584:	4505                	li	a0,1
    4586:	00001097          	auipc	ra,0x1
    458a:	e22080e7          	jalr	-478(ra) # 53a8 <exit>
  a = sbrk(0);
    458e:	4501                	li	a0,0
    4590:	00001097          	auipc	ra,0x1
    4594:	ea0080e7          	jalr	-352(ra) # 5430 <sbrk>
    4598:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    459a:	4901                	li	s2,0
    459c:	6985                	lui	s3,0x1
    459e:	38898993          	addi	s3,s3,904 # 1388 <exitwait+0x2>
    45a2:	a011                	j	45a6 <sbrkbasic+0x58>
    a = b + 1;
    45a4:	84be                	mv	s1,a5
    b = sbrk(1);
    45a6:	4505                	li	a0,1
    45a8:	00001097          	auipc	ra,0x1
    45ac:	e88080e7          	jalr	-376(ra) # 5430 <sbrk>
    if(b != a){
    45b0:	04951c63          	bne	a0,s1,4608 <sbrkbasic+0xba>
    *b = 1;
    45b4:	4785                	li	a5,1
    45b6:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    45ba:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    45be:	2905                	addiw	s2,s2,1
    45c0:	ff3912e3          	bne	s2,s3,45a4 <sbrkbasic+0x56>
  pid = fork();
    45c4:	00001097          	auipc	ra,0x1
    45c8:	ddc080e7          	jalr	-548(ra) # 53a0 <fork>
    45cc:	892a                	mv	s2,a0
  if(pid < 0){
    45ce:	04054d63          	bltz	a0,4628 <sbrkbasic+0xda>
  c = sbrk(1);
    45d2:	4505                	li	a0,1
    45d4:	00001097          	auipc	ra,0x1
    45d8:	e5c080e7          	jalr	-420(ra) # 5430 <sbrk>
  c = sbrk(1);
    45dc:	4505                	li	a0,1
    45de:	00001097          	auipc	ra,0x1
    45e2:	e52080e7          	jalr	-430(ra) # 5430 <sbrk>
  if(c != a + 1){
    45e6:	0489                	addi	s1,s1,2
    45e8:	04a48e63          	beq	s1,a0,4644 <sbrkbasic+0xf6>
    printf("%s: sbrk test failed post-fork\n", s);
    45ec:	85d2                	mv	a1,s4
    45ee:	00003517          	auipc	a0,0x3
    45f2:	cb250513          	addi	a0,a0,-846 # 72a0 <malloc+0x1ab2>
    45f6:	00001097          	auipc	ra,0x1
    45fa:	13a080e7          	jalr	314(ra) # 5730 <printf>
    exit(1);
    45fe:	4505                	li	a0,1
    4600:	00001097          	auipc	ra,0x1
    4604:	da8080e7          	jalr	-600(ra) # 53a8 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    4608:	86aa                	mv	a3,a0
    460a:	8626                	mv	a2,s1
    460c:	85ca                	mv	a1,s2
    460e:	00003517          	auipc	a0,0x3
    4612:	c5250513          	addi	a0,a0,-942 # 7260 <malloc+0x1a72>
    4616:	00001097          	auipc	ra,0x1
    461a:	11a080e7          	jalr	282(ra) # 5730 <printf>
      exit(1);
    461e:	4505                	li	a0,1
    4620:	00001097          	auipc	ra,0x1
    4624:	d88080e7          	jalr	-632(ra) # 53a8 <exit>
    printf("%s: sbrk test fork failed\n", s);
    4628:	85d2                	mv	a1,s4
    462a:	00003517          	auipc	a0,0x3
    462e:	c5650513          	addi	a0,a0,-938 # 7280 <malloc+0x1a92>
    4632:	00001097          	auipc	ra,0x1
    4636:	0fe080e7          	jalr	254(ra) # 5730 <printf>
    exit(1);
    463a:	4505                	li	a0,1
    463c:	00001097          	auipc	ra,0x1
    4640:	d6c080e7          	jalr	-660(ra) # 53a8 <exit>
  if(pid == 0)
    4644:	00091763          	bnez	s2,4652 <sbrkbasic+0x104>
    exit(0);
    4648:	4501                	li	a0,0
    464a:	00001097          	auipc	ra,0x1
    464e:	d5e080e7          	jalr	-674(ra) # 53a8 <exit>
  wait(&xstatus);
    4652:	fcc40513          	addi	a0,s0,-52
    4656:	00001097          	auipc	ra,0x1
    465a:	d5a080e7          	jalr	-678(ra) # 53b0 <wait>
  exit(xstatus);
    465e:	fcc42503          	lw	a0,-52(s0)
    4662:	00001097          	auipc	ra,0x1
    4666:	d46080e7          	jalr	-698(ra) # 53a8 <exit>

000000000000466a <sbrkmuch>:
{
    466a:	7179                	addi	sp,sp,-48
    466c:	f406                	sd	ra,40(sp)
    466e:	f022                	sd	s0,32(sp)
    4670:	ec26                	sd	s1,24(sp)
    4672:	e84a                	sd	s2,16(sp)
    4674:	e44e                	sd	s3,8(sp)
    4676:	e052                	sd	s4,0(sp)
    4678:	1800                	addi	s0,sp,48
    467a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    467c:	4501                	li	a0,0
    467e:	00001097          	auipc	ra,0x1
    4682:	db2080e7          	jalr	-590(ra) # 5430 <sbrk>
    4686:	892a                	mv	s2,a0
  a = sbrk(0);
    4688:	4501                	li	a0,0
    468a:	00001097          	auipc	ra,0x1
    468e:	da6080e7          	jalr	-602(ra) # 5430 <sbrk>
    4692:	84aa                	mv	s1,a0
  p = sbrk(amt);
    4694:	06400537          	lui	a0,0x6400
    4698:	9d05                	subw	a0,a0,s1
    469a:	00001097          	auipc	ra,0x1
    469e:	d96080e7          	jalr	-618(ra) # 5430 <sbrk>
  if (p != a) {
    46a2:	0aa49963          	bne	s1,a0,4754 <sbrkmuch+0xea>
  *lastaddr = 99;
    46a6:	064007b7          	lui	a5,0x6400
    46aa:	06300713          	li	a4,99
    46ae:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f2e3f>
  a = sbrk(0);
    46b2:	4501                	li	a0,0
    46b4:	00001097          	auipc	ra,0x1
    46b8:	d7c080e7          	jalr	-644(ra) # 5430 <sbrk>
    46bc:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    46be:	757d                	lui	a0,0xfffff
    46c0:	00001097          	auipc	ra,0x1
    46c4:	d70080e7          	jalr	-656(ra) # 5430 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    46c8:	57fd                	li	a5,-1
    46ca:	0af50363          	beq	a0,a5,4770 <sbrkmuch+0x106>
  c = sbrk(0);
    46ce:	4501                	li	a0,0
    46d0:	00001097          	auipc	ra,0x1
    46d4:	d60080e7          	jalr	-672(ra) # 5430 <sbrk>
  if(c != a - PGSIZE){
    46d8:	77fd                	lui	a5,0xfffff
    46da:	97a6                	add	a5,a5,s1
    46dc:	0af51863          	bne	a0,a5,478c <sbrkmuch+0x122>
  a = sbrk(0);
    46e0:	4501                	li	a0,0
    46e2:	00001097          	auipc	ra,0x1
    46e6:	d4e080e7          	jalr	-690(ra) # 5430 <sbrk>
    46ea:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    46ec:	6505                	lui	a0,0x1
    46ee:	00001097          	auipc	ra,0x1
    46f2:	d42080e7          	jalr	-702(ra) # 5430 <sbrk>
    46f6:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    46f8:	0aa49963          	bne	s1,a0,47aa <sbrkmuch+0x140>
    46fc:	4501                	li	a0,0
    46fe:	00001097          	auipc	ra,0x1
    4702:	d32080e7          	jalr	-718(ra) # 5430 <sbrk>
    4706:	6785                	lui	a5,0x1
    4708:	97a6                	add	a5,a5,s1
    470a:	0af51063          	bne	a0,a5,47aa <sbrkmuch+0x140>
  if(*lastaddr == 99){
    470e:	064007b7          	lui	a5,0x6400
    4712:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f2e3f>
    4716:	06300793          	li	a5,99
    471a:	0af70763          	beq	a4,a5,47c8 <sbrkmuch+0x15e>
  a = sbrk(0);
    471e:	4501                	li	a0,0
    4720:	00001097          	auipc	ra,0x1
    4724:	d10080e7          	jalr	-752(ra) # 5430 <sbrk>
    4728:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    472a:	4501                	li	a0,0
    472c:	00001097          	auipc	ra,0x1
    4730:	d04080e7          	jalr	-764(ra) # 5430 <sbrk>
    4734:	40a9053b          	subw	a0,s2,a0
    4738:	00001097          	auipc	ra,0x1
    473c:	cf8080e7          	jalr	-776(ra) # 5430 <sbrk>
  if(c != a){
    4740:	0aa49263          	bne	s1,a0,47e4 <sbrkmuch+0x17a>
}
    4744:	70a2                	ld	ra,40(sp)
    4746:	7402                	ld	s0,32(sp)
    4748:	64e2                	ld	s1,24(sp)
    474a:	6942                	ld	s2,16(sp)
    474c:	69a2                	ld	s3,8(sp)
    474e:	6a02                	ld	s4,0(sp)
    4750:	6145                	addi	sp,sp,48
    4752:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    4754:	85ce                	mv	a1,s3
    4756:	00003517          	auipc	a0,0x3
    475a:	b6a50513          	addi	a0,a0,-1174 # 72c0 <malloc+0x1ad2>
    475e:	00001097          	auipc	ra,0x1
    4762:	fd2080e7          	jalr	-46(ra) # 5730 <printf>
    exit(1);
    4766:	4505                	li	a0,1
    4768:	00001097          	auipc	ra,0x1
    476c:	c40080e7          	jalr	-960(ra) # 53a8 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    4770:	85ce                	mv	a1,s3
    4772:	00003517          	auipc	a0,0x3
    4776:	b9650513          	addi	a0,a0,-1130 # 7308 <malloc+0x1b1a>
    477a:	00001097          	auipc	ra,0x1
    477e:	fb6080e7          	jalr	-74(ra) # 5730 <printf>
    exit(1);
    4782:	4505                	li	a0,1
    4784:	00001097          	auipc	ra,0x1
    4788:	c24080e7          	jalr	-988(ra) # 53a8 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    478c:	862a                	mv	a2,a0
    478e:	85a6                	mv	a1,s1
    4790:	00003517          	auipc	a0,0x3
    4794:	b9850513          	addi	a0,a0,-1128 # 7328 <malloc+0x1b3a>
    4798:	00001097          	auipc	ra,0x1
    479c:	f98080e7          	jalr	-104(ra) # 5730 <printf>
    exit(1);
    47a0:	4505                	li	a0,1
    47a2:	00001097          	auipc	ra,0x1
    47a6:	c06080e7          	jalr	-1018(ra) # 53a8 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    47aa:	8652                	mv	a2,s4
    47ac:	85a6                	mv	a1,s1
    47ae:	00003517          	auipc	a0,0x3
    47b2:	bba50513          	addi	a0,a0,-1094 # 7368 <malloc+0x1b7a>
    47b6:	00001097          	auipc	ra,0x1
    47ba:	f7a080e7          	jalr	-134(ra) # 5730 <printf>
    exit(1);
    47be:	4505                	li	a0,1
    47c0:	00001097          	auipc	ra,0x1
    47c4:	be8080e7          	jalr	-1048(ra) # 53a8 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    47c8:	85ce                	mv	a1,s3
    47ca:	00003517          	auipc	a0,0x3
    47ce:	bce50513          	addi	a0,a0,-1074 # 7398 <malloc+0x1baa>
    47d2:	00001097          	auipc	ra,0x1
    47d6:	f5e080e7          	jalr	-162(ra) # 5730 <printf>
    exit(1);
    47da:	4505                	li	a0,1
    47dc:	00001097          	auipc	ra,0x1
    47e0:	bcc080e7          	jalr	-1076(ra) # 53a8 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    47e4:	862a                	mv	a2,a0
    47e6:	85a6                	mv	a1,s1
    47e8:	00003517          	auipc	a0,0x3
    47ec:	be850513          	addi	a0,a0,-1048 # 73d0 <malloc+0x1be2>
    47f0:	00001097          	auipc	ra,0x1
    47f4:	f40080e7          	jalr	-192(ra) # 5730 <printf>
    exit(1);
    47f8:	4505                	li	a0,1
    47fa:	00001097          	auipc	ra,0x1
    47fe:	bae080e7          	jalr	-1106(ra) # 53a8 <exit>

0000000000004802 <sbrkfail>:
{
    4802:	7119                	addi	sp,sp,-128
    4804:	fc86                	sd	ra,120(sp)
    4806:	f8a2                	sd	s0,112(sp)
    4808:	f4a6                	sd	s1,104(sp)
    480a:	f0ca                	sd	s2,96(sp)
    480c:	ecce                	sd	s3,88(sp)
    480e:	e8d2                	sd	s4,80(sp)
    4810:	e4d6                	sd	s5,72(sp)
    4812:	0100                	addi	s0,sp,128
    4814:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    4816:	fb040513          	addi	a0,s0,-80
    481a:	00001097          	auipc	ra,0x1
    481e:	b9e080e7          	jalr	-1122(ra) # 53b8 <pipe>
    4822:	e901                	bnez	a0,4832 <sbrkfail+0x30>
    4824:	f8040493          	addi	s1,s0,-128
    4828:	fa840a13          	addi	s4,s0,-88
    482c:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    482e:	5afd                	li	s5,-1
    4830:	a08d                	j	4892 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    4832:	85ca                	mv	a1,s2
    4834:	00002517          	auipc	a0,0x2
    4838:	dec50513          	addi	a0,a0,-532 # 6620 <malloc+0xe32>
    483c:	00001097          	auipc	ra,0x1
    4840:	ef4080e7          	jalr	-268(ra) # 5730 <printf>
    exit(1);
    4844:	4505                	li	a0,1
    4846:	00001097          	auipc	ra,0x1
    484a:	b62080e7          	jalr	-1182(ra) # 53a8 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    484e:	4501                	li	a0,0
    4850:	00001097          	auipc	ra,0x1
    4854:	be0080e7          	jalr	-1056(ra) # 5430 <sbrk>
    4858:	064007b7          	lui	a5,0x6400
    485c:	40a7853b          	subw	a0,a5,a0
    4860:	00001097          	auipc	ra,0x1
    4864:	bd0080e7          	jalr	-1072(ra) # 5430 <sbrk>
      write(fds[1], "x", 1);
    4868:	4605                	li	a2,1
    486a:	00002597          	auipc	a1,0x2
    486e:	e3658593          	addi	a1,a1,-458 # 66a0 <malloc+0xeb2>
    4872:	fb442503          	lw	a0,-76(s0)
    4876:	00001097          	auipc	ra,0x1
    487a:	b52080e7          	jalr	-1198(ra) # 53c8 <write>
      for(;;) sleep(1000);
    487e:	3e800513          	li	a0,1000
    4882:	00001097          	auipc	ra,0x1
    4886:	bb6080e7          	jalr	-1098(ra) # 5438 <sleep>
    488a:	bfd5                	j	487e <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    488c:	0991                	addi	s3,s3,4
    488e:	03498563          	beq	s3,s4,48b8 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    4892:	00001097          	auipc	ra,0x1
    4896:	b0e080e7          	jalr	-1266(ra) # 53a0 <fork>
    489a:	00a9a023          	sw	a0,0(s3)
    489e:	d945                	beqz	a0,484e <sbrkfail+0x4c>
    if(pids[i] != -1)
    48a0:	ff5506e3          	beq	a0,s5,488c <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    48a4:	4605                	li	a2,1
    48a6:	faf40593          	addi	a1,s0,-81
    48aa:	fb042503          	lw	a0,-80(s0)
    48ae:	00001097          	auipc	ra,0x1
    48b2:	b12080e7          	jalr	-1262(ra) # 53c0 <read>
    48b6:	bfd9                	j	488c <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    48b8:	6505                	lui	a0,0x1
    48ba:	00001097          	auipc	ra,0x1
    48be:	b76080e7          	jalr	-1162(ra) # 5430 <sbrk>
    48c2:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    48c4:	5afd                	li	s5,-1
    48c6:	a021                	j	48ce <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48c8:	0491                	addi	s1,s1,4
    48ca:	01448f63          	beq	s1,s4,48e8 <sbrkfail+0xe6>
    if(pids[i] == -1)
    48ce:	4088                	lw	a0,0(s1)
    48d0:	ff550ce3          	beq	a0,s5,48c8 <sbrkfail+0xc6>
    kill(pids[i]);
    48d4:	00001097          	auipc	ra,0x1
    48d8:	b04080e7          	jalr	-1276(ra) # 53d8 <kill>
    wait(0);
    48dc:	4501                	li	a0,0
    48de:	00001097          	auipc	ra,0x1
    48e2:	ad2080e7          	jalr	-1326(ra) # 53b0 <wait>
    48e6:	b7cd                	j	48c8 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    48e8:	57fd                	li	a5,-1
    48ea:	02f98e63          	beq	s3,a5,4926 <sbrkfail+0x124>
  pid = fork();
    48ee:	00001097          	auipc	ra,0x1
    48f2:	ab2080e7          	jalr	-1358(ra) # 53a0 <fork>
    48f6:	84aa                	mv	s1,a0
  if(pid < 0){
    48f8:	04054563          	bltz	a0,4942 <sbrkfail+0x140>
  if(pid == 0){
    48fc:	c12d                	beqz	a0,495e <sbrkfail+0x15c>
  wait(&xstatus);
    48fe:	fbc40513          	addi	a0,s0,-68
    4902:	00001097          	auipc	ra,0x1
    4906:	aae080e7          	jalr	-1362(ra) # 53b0 <wait>
  if(xstatus != -1)
    490a:	fbc42703          	lw	a4,-68(s0)
    490e:	57fd                	li	a5,-1
    4910:	08f71c63          	bne	a4,a5,49a8 <sbrkfail+0x1a6>
}
    4914:	70e6                	ld	ra,120(sp)
    4916:	7446                	ld	s0,112(sp)
    4918:	74a6                	ld	s1,104(sp)
    491a:	7906                	ld	s2,96(sp)
    491c:	69e6                	ld	s3,88(sp)
    491e:	6a46                	ld	s4,80(sp)
    4920:	6aa6                	ld	s5,72(sp)
    4922:	6109                	addi	sp,sp,128
    4924:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4926:	85ca                	mv	a1,s2
    4928:	00003517          	auipc	a0,0x3
    492c:	ad050513          	addi	a0,a0,-1328 # 73f8 <malloc+0x1c0a>
    4930:	00001097          	auipc	ra,0x1
    4934:	e00080e7          	jalr	-512(ra) # 5730 <printf>
    exit(1);
    4938:	4505                	li	a0,1
    493a:	00001097          	auipc	ra,0x1
    493e:	a6e080e7          	jalr	-1426(ra) # 53a8 <exit>
    printf("%s: fork failed\n", s);
    4942:	85ca                	mv	a1,s2
    4944:	00001517          	auipc	a0,0x1
    4948:	3ac50513          	addi	a0,a0,940 # 5cf0 <malloc+0x502>
    494c:	00001097          	auipc	ra,0x1
    4950:	de4080e7          	jalr	-540(ra) # 5730 <printf>
    exit(1);
    4954:	4505                	li	a0,1
    4956:	00001097          	auipc	ra,0x1
    495a:	a52080e7          	jalr	-1454(ra) # 53a8 <exit>
    a = sbrk(0);
    495e:	4501                	li	a0,0
    4960:	00001097          	auipc	ra,0x1
    4964:	ad0080e7          	jalr	-1328(ra) # 5430 <sbrk>
    4968:	892a                	mv	s2,a0
    sbrk(10*BIG);
    496a:	3e800537          	lui	a0,0x3e800
    496e:	00001097          	auipc	ra,0x1
    4972:	ac2080e7          	jalr	-1342(ra) # 5430 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4976:	874a                	mv	a4,s2
    4978:	3e8007b7          	lui	a5,0x3e800
    497c:	97ca                	add	a5,a5,s2
    497e:	6685                	lui	a3,0x1
      n += *(a+i);
    4980:	00074603          	lbu	a2,0(a4)
    4984:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4986:	9736                	add	a4,a4,a3
    4988:	fef71ce3          	bne	a4,a5,4980 <sbrkfail+0x17e>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    498c:	85a6                	mv	a1,s1
    498e:	00003517          	auipc	a0,0x3
    4992:	a8a50513          	addi	a0,a0,-1398 # 7418 <malloc+0x1c2a>
    4996:	00001097          	auipc	ra,0x1
    499a:	d9a080e7          	jalr	-614(ra) # 5730 <printf>
    exit(1);
    499e:	4505                	li	a0,1
    49a0:	00001097          	auipc	ra,0x1
    49a4:	a08080e7          	jalr	-1528(ra) # 53a8 <exit>
    exit(1);
    49a8:	4505                	li	a0,1
    49aa:	00001097          	auipc	ra,0x1
    49ae:	9fe080e7          	jalr	-1538(ra) # 53a8 <exit>

00000000000049b2 <sbrkarg>:
{
    49b2:	7179                	addi	sp,sp,-48
    49b4:	f406                	sd	ra,40(sp)
    49b6:	f022                	sd	s0,32(sp)
    49b8:	ec26                	sd	s1,24(sp)
    49ba:	e84a                	sd	s2,16(sp)
    49bc:	e44e                	sd	s3,8(sp)
    49be:	1800                	addi	s0,sp,48
    49c0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    49c2:	6505                	lui	a0,0x1
    49c4:	00001097          	auipc	ra,0x1
    49c8:	a6c080e7          	jalr	-1428(ra) # 5430 <sbrk>
    49cc:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    49ce:	20100593          	li	a1,513
    49d2:	00003517          	auipc	a0,0x3
    49d6:	a7650513          	addi	a0,a0,-1418 # 7448 <malloc+0x1c5a>
    49da:	00001097          	auipc	ra,0x1
    49de:	a0e080e7          	jalr	-1522(ra) # 53e8 <open>
    49e2:	84aa                	mv	s1,a0
  unlink("sbrk");
    49e4:	00003517          	auipc	a0,0x3
    49e8:	a6450513          	addi	a0,a0,-1436 # 7448 <malloc+0x1c5a>
    49ec:	00001097          	auipc	ra,0x1
    49f0:	a0c080e7          	jalr	-1524(ra) # 53f8 <unlink>
  if(fd < 0)  {
    49f4:	0404c163          	bltz	s1,4a36 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    49f8:	6605                	lui	a2,0x1
    49fa:	85ca                	mv	a1,s2
    49fc:	8526                	mv	a0,s1
    49fe:	00001097          	auipc	ra,0x1
    4a02:	9ca080e7          	jalr	-1590(ra) # 53c8 <write>
    4a06:	04054663          	bltz	a0,4a52 <sbrkarg+0xa0>
  close(fd);
    4a0a:	8526                	mv	a0,s1
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	9c4080e7          	jalr	-1596(ra) # 53d0 <close>
  a = sbrk(PGSIZE);
    4a14:	6505                	lui	a0,0x1
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	a1a080e7          	jalr	-1510(ra) # 5430 <sbrk>
  if(pipe((int *) a) != 0){
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	99a080e7          	jalr	-1638(ra) # 53b8 <pipe>
    4a26:	e521                	bnez	a0,4a6e <sbrkarg+0xbc>
}
    4a28:	70a2                	ld	ra,40(sp)
    4a2a:	7402                	ld	s0,32(sp)
    4a2c:	64e2                	ld	s1,24(sp)
    4a2e:	6942                	ld	s2,16(sp)
    4a30:	69a2                	ld	s3,8(sp)
    4a32:	6145                	addi	sp,sp,48
    4a34:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    4a36:	85ce                	mv	a1,s3
    4a38:	00003517          	auipc	a0,0x3
    4a3c:	a1850513          	addi	a0,a0,-1512 # 7450 <malloc+0x1c62>
    4a40:	00001097          	auipc	ra,0x1
    4a44:	cf0080e7          	jalr	-784(ra) # 5730 <printf>
    exit(1);
    4a48:	4505                	li	a0,1
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	95e080e7          	jalr	-1698(ra) # 53a8 <exit>
    printf("%s: write sbrk failed\n", s);
    4a52:	85ce                	mv	a1,s3
    4a54:	00003517          	auipc	a0,0x3
    4a58:	a1450513          	addi	a0,a0,-1516 # 7468 <malloc+0x1c7a>
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	cd4080e7          	jalr	-812(ra) # 5730 <printf>
    exit(1);
    4a64:	4505                	li	a0,1
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	942080e7          	jalr	-1726(ra) # 53a8 <exit>
    printf("%s: pipe() failed\n", s);
    4a6e:	85ce                	mv	a1,s3
    4a70:	00002517          	auipc	a0,0x2
    4a74:	bb050513          	addi	a0,a0,-1104 # 6620 <malloc+0xe32>
    4a78:	00001097          	auipc	ra,0x1
    4a7c:	cb8080e7          	jalr	-840(ra) # 5730 <printf>
    exit(1);
    4a80:	4505                	li	a0,1
    4a82:	00001097          	auipc	ra,0x1
    4a86:	926080e7          	jalr	-1754(ra) # 53a8 <exit>

0000000000004a8a <argptest>:
{
    4a8a:	1101                	addi	sp,sp,-32
    4a8c:	ec06                	sd	ra,24(sp)
    4a8e:	e822                	sd	s0,16(sp)
    4a90:	e426                	sd	s1,8(sp)
    4a92:	e04a                	sd	s2,0(sp)
    4a94:	1000                	addi	s0,sp,32
    4a96:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    4a98:	4581                	li	a1,0
    4a9a:	00003517          	auipc	a0,0x3
    4a9e:	9e650513          	addi	a0,a0,-1562 # 7480 <malloc+0x1c92>
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	946080e7          	jalr	-1722(ra) # 53e8 <open>
  if (fd < 0) {
    4aaa:	02054b63          	bltz	a0,4ae0 <argptest+0x56>
    4aae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    4ab0:	4501                	li	a0,0
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	97e080e7          	jalr	-1666(ra) # 5430 <sbrk>
    4aba:	567d                	li	a2,-1
    4abc:	fff50593          	addi	a1,a0,-1
    4ac0:	8526                	mv	a0,s1
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	8fe080e7          	jalr	-1794(ra) # 53c0 <read>
  close(fd);
    4aca:	8526                	mv	a0,s1
    4acc:	00001097          	auipc	ra,0x1
    4ad0:	904080e7          	jalr	-1788(ra) # 53d0 <close>
}
    4ad4:	60e2                	ld	ra,24(sp)
    4ad6:	6442                	ld	s0,16(sp)
    4ad8:	64a2                	ld	s1,8(sp)
    4ada:	6902                	ld	s2,0(sp)
    4adc:	6105                	addi	sp,sp,32
    4ade:	8082                	ret
    printf("%s: open failed\n", s);
    4ae0:	85ca                	mv	a1,s2
    4ae2:	00002517          	auipc	a0,0x2
    4ae6:	9de50513          	addi	a0,a0,-1570 # 64c0 <malloc+0xcd2>
    4aea:	00001097          	auipc	ra,0x1
    4aee:	c46080e7          	jalr	-954(ra) # 5730 <printf>
    exit(1);
    4af2:	4505                	li	a0,1
    4af4:	00001097          	auipc	ra,0x1
    4af8:	8b4080e7          	jalr	-1868(ra) # 53a8 <exit>

0000000000004afc <sbrkbugs>:
{
    4afc:	1141                	addi	sp,sp,-16
    4afe:	e406                	sd	ra,8(sp)
    4b00:	e022                	sd	s0,0(sp)
    4b02:	0800                	addi	s0,sp,16
  int pid = fork();
    4b04:	00001097          	auipc	ra,0x1
    4b08:	89c080e7          	jalr	-1892(ra) # 53a0 <fork>
  if(pid < 0){
    4b0c:	02054263          	bltz	a0,4b30 <sbrkbugs+0x34>
  if(pid == 0){
    4b10:	ed0d                	bnez	a0,4b4a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    4b12:	00001097          	auipc	ra,0x1
    4b16:	91e080e7          	jalr	-1762(ra) # 5430 <sbrk>
    sbrk(-sz);
    4b1a:	40a0053b          	negw	a0,a0
    4b1e:	00001097          	auipc	ra,0x1
    4b22:	912080e7          	jalr	-1774(ra) # 5430 <sbrk>
    exit(0);
    4b26:	4501                	li	a0,0
    4b28:	00001097          	auipc	ra,0x1
    4b2c:	880080e7          	jalr	-1920(ra) # 53a8 <exit>
    printf("fork failed\n");
    4b30:	00002517          	auipc	a0,0x2
    4b34:	ac050513          	addi	a0,a0,-1344 # 65f0 <malloc+0xe02>
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	bf8080e7          	jalr	-1032(ra) # 5730 <printf>
    exit(1);
    4b40:	4505                	li	a0,1
    4b42:	00001097          	auipc	ra,0x1
    4b46:	866080e7          	jalr	-1946(ra) # 53a8 <exit>
  wait(0);
    4b4a:	4501                	li	a0,0
    4b4c:	00001097          	auipc	ra,0x1
    4b50:	864080e7          	jalr	-1948(ra) # 53b0 <wait>
  pid = fork();
    4b54:	00001097          	auipc	ra,0x1
    4b58:	84c080e7          	jalr	-1972(ra) # 53a0 <fork>
  if(pid < 0){
    4b5c:	02054563          	bltz	a0,4b86 <sbrkbugs+0x8a>
  if(pid == 0){
    4b60:	e121                	bnez	a0,4ba0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    4b62:	00001097          	auipc	ra,0x1
    4b66:	8ce080e7          	jalr	-1842(ra) # 5430 <sbrk>
    sbrk(-(sz - 3500));
    4b6a:	6785                	lui	a5,0x1
    4b6c:	dac7879b          	addiw	a5,a5,-596
    4b70:	40a7853b          	subw	a0,a5,a0
    4b74:	00001097          	auipc	ra,0x1
    4b78:	8bc080e7          	jalr	-1860(ra) # 5430 <sbrk>
    exit(0);
    4b7c:	4501                	li	a0,0
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	82a080e7          	jalr	-2006(ra) # 53a8 <exit>
    printf("fork failed\n");
    4b86:	00002517          	auipc	a0,0x2
    4b8a:	a6a50513          	addi	a0,a0,-1430 # 65f0 <malloc+0xe02>
    4b8e:	00001097          	auipc	ra,0x1
    4b92:	ba2080e7          	jalr	-1118(ra) # 5730 <printf>
    exit(1);
    4b96:	4505                	li	a0,1
    4b98:	00001097          	auipc	ra,0x1
    4b9c:	810080e7          	jalr	-2032(ra) # 53a8 <exit>
  wait(0);
    4ba0:	4501                	li	a0,0
    4ba2:	00001097          	auipc	ra,0x1
    4ba6:	80e080e7          	jalr	-2034(ra) # 53b0 <wait>
  pid = fork();
    4baa:	00000097          	auipc	ra,0x0
    4bae:	7f6080e7          	jalr	2038(ra) # 53a0 <fork>
  if(pid < 0){
    4bb2:	02054a63          	bltz	a0,4be6 <sbrkbugs+0xea>
  if(pid == 0){
    4bb6:	e529                	bnez	a0,4c00 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    4bb8:	00001097          	auipc	ra,0x1
    4bbc:	878080e7          	jalr	-1928(ra) # 5430 <sbrk>
    4bc0:	67ad                	lui	a5,0xb
    4bc2:	8007879b          	addiw	a5,a5,-2048
    4bc6:	40a7853b          	subw	a0,a5,a0
    4bca:	00001097          	auipc	ra,0x1
    4bce:	866080e7          	jalr	-1946(ra) # 5430 <sbrk>
    sbrk(-10);
    4bd2:	5559                	li	a0,-10
    4bd4:	00001097          	auipc	ra,0x1
    4bd8:	85c080e7          	jalr	-1956(ra) # 5430 <sbrk>
    exit(0);
    4bdc:	4501                	li	a0,0
    4bde:	00000097          	auipc	ra,0x0
    4be2:	7ca080e7          	jalr	1994(ra) # 53a8 <exit>
    printf("fork failed\n");
    4be6:	00002517          	auipc	a0,0x2
    4bea:	a0a50513          	addi	a0,a0,-1526 # 65f0 <malloc+0xe02>
    4bee:	00001097          	auipc	ra,0x1
    4bf2:	b42080e7          	jalr	-1214(ra) # 5730 <printf>
    exit(1);
    4bf6:	4505                	li	a0,1
    4bf8:	00000097          	auipc	ra,0x0
    4bfc:	7b0080e7          	jalr	1968(ra) # 53a8 <exit>
  wait(0);
    4c00:	4501                	li	a0,0
    4c02:	00000097          	auipc	ra,0x0
    4c06:	7ae080e7          	jalr	1966(ra) # 53b0 <wait>
  exit(0);
    4c0a:	4501                	li	a0,0
    4c0c:	00000097          	auipc	ra,0x0
    4c10:	79c080e7          	jalr	1948(ra) # 53a8 <exit>

0000000000004c14 <dirtest>:
{
    4c14:	1101                	addi	sp,sp,-32
    4c16:	ec06                	sd	ra,24(sp)
    4c18:	e822                	sd	s0,16(sp)
    4c1a:	e426                	sd	s1,8(sp)
    4c1c:	1000                	addi	s0,sp,32
    4c1e:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    4c20:	00003517          	auipc	a0,0x3
    4c24:	86850513          	addi	a0,a0,-1944 # 7488 <malloc+0x1c9a>
    4c28:	00001097          	auipc	ra,0x1
    4c2c:	b08080e7          	jalr	-1272(ra) # 5730 <printf>
  if(mkdir("dir0") < 0){
    4c30:	00003517          	auipc	a0,0x3
    4c34:	86850513          	addi	a0,a0,-1944 # 7498 <malloc+0x1caa>
    4c38:	00000097          	auipc	ra,0x0
    4c3c:	7d8080e7          	jalr	2008(ra) # 5410 <mkdir>
    4c40:	04054d63          	bltz	a0,4c9a <dirtest+0x86>
  if(chdir("dir0") < 0){
    4c44:	00003517          	auipc	a0,0x3
    4c48:	85450513          	addi	a0,a0,-1964 # 7498 <malloc+0x1caa>
    4c4c:	00000097          	auipc	ra,0x0
    4c50:	7cc080e7          	jalr	1996(ra) # 5418 <chdir>
    4c54:	06054163          	bltz	a0,4cb6 <dirtest+0xa2>
  if(chdir("..") < 0){
    4c58:	00001517          	auipc	a0,0x1
    4c5c:	00850513          	addi	a0,a0,8 # 5c60 <malloc+0x472>
    4c60:	00000097          	auipc	ra,0x0
    4c64:	7b8080e7          	jalr	1976(ra) # 5418 <chdir>
    4c68:	06054563          	bltz	a0,4cd2 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    4c6c:	00003517          	auipc	a0,0x3
    4c70:	82c50513          	addi	a0,a0,-2004 # 7498 <malloc+0x1caa>
    4c74:	00000097          	auipc	ra,0x0
    4c78:	784080e7          	jalr	1924(ra) # 53f8 <unlink>
    4c7c:	06054963          	bltz	a0,4cee <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    4c80:	00003517          	auipc	a0,0x3
    4c84:	86850513          	addi	a0,a0,-1944 # 74e8 <malloc+0x1cfa>
    4c88:	00001097          	auipc	ra,0x1
    4c8c:	aa8080e7          	jalr	-1368(ra) # 5730 <printf>
}
    4c90:	60e2                	ld	ra,24(sp)
    4c92:	6442                	ld	s0,16(sp)
    4c94:	64a2                	ld	s1,8(sp)
    4c96:	6105                	addi	sp,sp,32
    4c98:	8082                	ret
    printf("%s: mkdir failed\n", s);
    4c9a:	85a6                	mv	a1,s1
    4c9c:	00001517          	auipc	a0,0x1
    4ca0:	ee450513          	addi	a0,a0,-284 # 5b80 <malloc+0x392>
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	a8c080e7          	jalr	-1396(ra) # 5730 <printf>
    exit(1);
    4cac:	4505                	li	a0,1
    4cae:	00000097          	auipc	ra,0x0
    4cb2:	6fa080e7          	jalr	1786(ra) # 53a8 <exit>
    printf("%s: chdir dir0 failed\n", s);
    4cb6:	85a6                	mv	a1,s1
    4cb8:	00002517          	auipc	a0,0x2
    4cbc:	7e850513          	addi	a0,a0,2024 # 74a0 <malloc+0x1cb2>
    4cc0:	00001097          	auipc	ra,0x1
    4cc4:	a70080e7          	jalr	-1424(ra) # 5730 <printf>
    exit(1);
    4cc8:	4505                	li	a0,1
    4cca:	00000097          	auipc	ra,0x0
    4cce:	6de080e7          	jalr	1758(ra) # 53a8 <exit>
    printf("%s: chdir .. failed\n", s);
    4cd2:	85a6                	mv	a1,s1
    4cd4:	00002517          	auipc	a0,0x2
    4cd8:	7e450513          	addi	a0,a0,2020 # 74b8 <malloc+0x1cca>
    4cdc:	00001097          	auipc	ra,0x1
    4ce0:	a54080e7          	jalr	-1452(ra) # 5730 <printf>
    exit(1);
    4ce4:	4505                	li	a0,1
    4ce6:	00000097          	auipc	ra,0x0
    4cea:	6c2080e7          	jalr	1730(ra) # 53a8 <exit>
    printf("%s: unlink dir0 failed\n", s);
    4cee:	85a6                	mv	a1,s1
    4cf0:	00002517          	auipc	a0,0x2
    4cf4:	7e050513          	addi	a0,a0,2016 # 74d0 <malloc+0x1ce2>
    4cf8:	00001097          	auipc	ra,0x1
    4cfc:	a38080e7          	jalr	-1480(ra) # 5730 <printf>
    exit(1);
    4d00:	4505                	li	a0,1
    4d02:	00000097          	auipc	ra,0x0
    4d06:	6a6080e7          	jalr	1702(ra) # 53a8 <exit>

0000000000004d0a <fsfull>:
{
    4d0a:	7171                	addi	sp,sp,-176
    4d0c:	f506                	sd	ra,168(sp)
    4d0e:	f122                	sd	s0,160(sp)
    4d10:	ed26                	sd	s1,152(sp)
    4d12:	e94a                	sd	s2,144(sp)
    4d14:	e54e                	sd	s3,136(sp)
    4d16:	e152                	sd	s4,128(sp)
    4d18:	fcd6                	sd	s5,120(sp)
    4d1a:	f8da                	sd	s6,112(sp)
    4d1c:	f4de                	sd	s7,104(sp)
    4d1e:	f0e2                	sd	s8,96(sp)
    4d20:	ece6                	sd	s9,88(sp)
    4d22:	e8ea                	sd	s10,80(sp)
    4d24:	e4ee                	sd	s11,72(sp)
    4d26:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4d28:	00002517          	auipc	a0,0x2
    4d2c:	7d850513          	addi	a0,a0,2008 # 7500 <malloc+0x1d12>
    4d30:	00001097          	auipc	ra,0x1
    4d34:	a00080e7          	jalr	-1536(ra) # 5730 <printf>
  for(nfiles = 0; ; nfiles++){
    4d38:	4481                	li	s1,0
    name[0] = 'f';
    4d3a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4d3e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d42:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d46:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4d48:	00002c97          	auipc	s9,0x2
    4d4c:	7c8c8c93          	addi	s9,s9,1992 # 7510 <malloc+0x1d22>
    int total = 0;
    4d50:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4d52:	00005a17          	auipc	s4,0x5
    4d56:	45ea0a13          	addi	s4,s4,1118 # a1b0 <buf>
    name[0] = 'f';
    4d5a:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d5e:	0384c7bb          	divw	a5,s1,s8
    4d62:	0307879b          	addiw	a5,a5,48
    4d66:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d6a:	0384e7bb          	remw	a5,s1,s8
    4d6e:	0377c7bb          	divw	a5,a5,s7
    4d72:	0307879b          	addiw	a5,a5,48
    4d76:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d7a:	0374e7bb          	remw	a5,s1,s7
    4d7e:	0367c7bb          	divw	a5,a5,s6
    4d82:	0307879b          	addiw	a5,a5,48
    4d86:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d8a:	0364e7bb          	remw	a5,s1,s6
    4d8e:	0307879b          	addiw	a5,a5,48
    4d92:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4d96:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4d9a:	f5040593          	addi	a1,s0,-176
    4d9e:	8566                	mv	a0,s9
    4da0:	00001097          	auipc	ra,0x1
    4da4:	990080e7          	jalr	-1648(ra) # 5730 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4da8:	20200593          	li	a1,514
    4dac:	f5040513          	addi	a0,s0,-176
    4db0:	00000097          	auipc	ra,0x0
    4db4:	638080e7          	jalr	1592(ra) # 53e8 <open>
    4db8:	892a                	mv	s2,a0
    if(fd < 0){
    4dba:	0a055663          	bgez	a0,4e66 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4dbe:	f5040593          	addi	a1,s0,-176
    4dc2:	00002517          	auipc	a0,0x2
    4dc6:	75e50513          	addi	a0,a0,1886 # 7520 <malloc+0x1d32>
    4dca:	00001097          	auipc	ra,0x1
    4dce:	966080e7          	jalr	-1690(ra) # 5730 <printf>
  while(nfiles >= 0){
    4dd2:	0604c363          	bltz	s1,4e38 <fsfull+0x12e>
    name[0] = 'f';
    4dd6:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4dda:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4dde:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4de2:	4929                	li	s2,10
  while(nfiles >= 0){
    4de4:	5afd                	li	s5,-1
    name[0] = 'f';
    4de6:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4dea:	0344c7bb          	divw	a5,s1,s4
    4dee:	0307879b          	addiw	a5,a5,48
    4df2:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4df6:	0344e7bb          	remw	a5,s1,s4
    4dfa:	0337c7bb          	divw	a5,a5,s3
    4dfe:	0307879b          	addiw	a5,a5,48
    4e02:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e06:	0334e7bb          	remw	a5,s1,s3
    4e0a:	0327c7bb          	divw	a5,a5,s2
    4e0e:	0307879b          	addiw	a5,a5,48
    4e12:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e16:	0324e7bb          	remw	a5,s1,s2
    4e1a:	0307879b          	addiw	a5,a5,48
    4e1e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e22:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4e26:	f5040513          	addi	a0,s0,-176
    4e2a:	00000097          	auipc	ra,0x0
    4e2e:	5ce080e7          	jalr	1486(ra) # 53f8 <unlink>
    nfiles--;
    4e32:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4e34:	fb5499e3          	bne	s1,s5,4de6 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4e38:	00002517          	auipc	a0,0x2
    4e3c:	71850513          	addi	a0,a0,1816 # 7550 <malloc+0x1d62>
    4e40:	00001097          	auipc	ra,0x1
    4e44:	8f0080e7          	jalr	-1808(ra) # 5730 <printf>
}
    4e48:	70aa                	ld	ra,168(sp)
    4e4a:	740a                	ld	s0,160(sp)
    4e4c:	64ea                	ld	s1,152(sp)
    4e4e:	694a                	ld	s2,144(sp)
    4e50:	69aa                	ld	s3,136(sp)
    4e52:	6a0a                	ld	s4,128(sp)
    4e54:	7ae6                	ld	s5,120(sp)
    4e56:	7b46                	ld	s6,112(sp)
    4e58:	7ba6                	ld	s7,104(sp)
    4e5a:	7c06                	ld	s8,96(sp)
    4e5c:	6ce6                	ld	s9,88(sp)
    4e5e:	6d46                	ld	s10,80(sp)
    4e60:	6da6                	ld	s11,72(sp)
    4e62:	614d                	addi	sp,sp,176
    4e64:	8082                	ret
    int total = 0;
    4e66:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4e68:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4e6c:	40000613          	li	a2,1024
    4e70:	85d2                	mv	a1,s4
    4e72:	854a                	mv	a0,s2
    4e74:	00000097          	auipc	ra,0x0
    4e78:	554080e7          	jalr	1364(ra) # 53c8 <write>
      if(cc < BSIZE)
    4e7c:	00aad563          	bge	s5,a0,4e86 <fsfull+0x17c>
      total += cc;
    4e80:	00a989bb          	addw	s3,s3,a0
    while(1){
    4e84:	b7e5                	j	4e6c <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4e86:	85ce                	mv	a1,s3
    4e88:	00002517          	auipc	a0,0x2
    4e8c:	6b050513          	addi	a0,a0,1712 # 7538 <malloc+0x1d4a>
    4e90:	00001097          	auipc	ra,0x1
    4e94:	8a0080e7          	jalr	-1888(ra) # 5730 <printf>
    close(fd);
    4e98:	854a                	mv	a0,s2
    4e9a:	00000097          	auipc	ra,0x0
    4e9e:	536080e7          	jalr	1334(ra) # 53d0 <close>
    if(total == 0)
    4ea2:	f20988e3          	beqz	s3,4dd2 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4ea6:	2485                	addiw	s1,s1,1
    4ea8:	bd4d                	j	4d5a <fsfull+0x50>

0000000000004eaa <rand>:
{
    4eaa:	1141                	addi	sp,sp,-16
    4eac:	e422                	sd	s0,8(sp)
    4eae:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4eb0:	00003717          	auipc	a4,0x3
    4eb4:	ad870713          	addi	a4,a4,-1320 # 7988 <randstate>
    4eb8:	6308                	ld	a0,0(a4)
    4eba:	001967b7          	lui	a5,0x196
    4ebe:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18944d>
    4ec2:	02f50533          	mul	a0,a0,a5
    4ec6:	3c6ef7b7          	lui	a5,0x3c6ef
    4eca:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e219f>
    4ece:	953e                	add	a0,a0,a5
    4ed0:	e308                	sd	a0,0(a4)
}
    4ed2:	2501                	sext.w	a0,a0
    4ed4:	6422                	ld	s0,8(sp)
    4ed6:	0141                	addi	sp,sp,16
    4ed8:	8082                	ret

0000000000004eda <badwrite>:
{
    4eda:	7179                	addi	sp,sp,-48
    4edc:	f406                	sd	ra,40(sp)
    4ede:	f022                	sd	s0,32(sp)
    4ee0:	ec26                	sd	s1,24(sp)
    4ee2:	e84a                	sd	s2,16(sp)
    4ee4:	e44e                	sd	s3,8(sp)
    4ee6:	e052                	sd	s4,0(sp)
    4ee8:	1800                	addi	s0,sp,48
  unlink("junk");
    4eea:	00002517          	auipc	a0,0x2
    4eee:	67e50513          	addi	a0,a0,1662 # 7568 <malloc+0x1d7a>
    4ef2:	00000097          	auipc	ra,0x0
    4ef6:	506080e7          	jalr	1286(ra) # 53f8 <unlink>
    4efa:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4efe:	00002997          	auipc	s3,0x2
    4f02:	66a98993          	addi	s3,s3,1642 # 7568 <malloc+0x1d7a>
    write(fd, (char*)0xffffffffffL, 1);
    4f06:	5a7d                	li	s4,-1
    4f08:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f0c:	20100593          	li	a1,513
    4f10:	854e                	mv	a0,s3
    4f12:	00000097          	auipc	ra,0x0
    4f16:	4d6080e7          	jalr	1238(ra) # 53e8 <open>
    4f1a:	84aa                	mv	s1,a0
    if(fd < 0){
    4f1c:	06054b63          	bltz	a0,4f92 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4f20:	4605                	li	a2,1
    4f22:	85d2                	mv	a1,s4
    4f24:	00000097          	auipc	ra,0x0
    4f28:	4a4080e7          	jalr	1188(ra) # 53c8 <write>
    close(fd);
    4f2c:	8526                	mv	a0,s1
    4f2e:	00000097          	auipc	ra,0x0
    4f32:	4a2080e7          	jalr	1186(ra) # 53d0 <close>
    unlink("junk");
    4f36:	854e                	mv	a0,s3
    4f38:	00000097          	auipc	ra,0x0
    4f3c:	4c0080e7          	jalr	1216(ra) # 53f8 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4f40:	397d                	addiw	s2,s2,-1
    4f42:	fc0915e3          	bnez	s2,4f0c <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4f46:	20100593          	li	a1,513
    4f4a:	00002517          	auipc	a0,0x2
    4f4e:	61e50513          	addi	a0,a0,1566 # 7568 <malloc+0x1d7a>
    4f52:	00000097          	auipc	ra,0x0
    4f56:	496080e7          	jalr	1174(ra) # 53e8 <open>
    4f5a:	84aa                	mv	s1,a0
  if(fd < 0){
    4f5c:	04054863          	bltz	a0,4fac <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4f60:	4605                	li	a2,1
    4f62:	00001597          	auipc	a1,0x1
    4f66:	73e58593          	addi	a1,a1,1854 # 66a0 <malloc+0xeb2>
    4f6a:	00000097          	auipc	ra,0x0
    4f6e:	45e080e7          	jalr	1118(ra) # 53c8 <write>
    4f72:	4785                	li	a5,1
    4f74:	04f50963          	beq	a0,a5,4fc6 <badwrite+0xec>
    printf("write failed\n");
    4f78:	00002517          	auipc	a0,0x2
    4f7c:	61050513          	addi	a0,a0,1552 # 7588 <malloc+0x1d9a>
    4f80:	00000097          	auipc	ra,0x0
    4f84:	7b0080e7          	jalr	1968(ra) # 5730 <printf>
    exit(1);
    4f88:	4505                	li	a0,1
    4f8a:	00000097          	auipc	ra,0x0
    4f8e:	41e080e7          	jalr	1054(ra) # 53a8 <exit>
      printf("open junk failed\n");
    4f92:	00002517          	auipc	a0,0x2
    4f96:	5de50513          	addi	a0,a0,1502 # 7570 <malloc+0x1d82>
    4f9a:	00000097          	auipc	ra,0x0
    4f9e:	796080e7          	jalr	1942(ra) # 5730 <printf>
      exit(1);
    4fa2:	4505                	li	a0,1
    4fa4:	00000097          	auipc	ra,0x0
    4fa8:	404080e7          	jalr	1028(ra) # 53a8 <exit>
    printf("open junk failed\n");
    4fac:	00002517          	auipc	a0,0x2
    4fb0:	5c450513          	addi	a0,a0,1476 # 7570 <malloc+0x1d82>
    4fb4:	00000097          	auipc	ra,0x0
    4fb8:	77c080e7          	jalr	1916(ra) # 5730 <printf>
    exit(1);
    4fbc:	4505                	li	a0,1
    4fbe:	00000097          	auipc	ra,0x0
    4fc2:	3ea080e7          	jalr	1002(ra) # 53a8 <exit>
  close(fd);
    4fc6:	8526                	mv	a0,s1
    4fc8:	00000097          	auipc	ra,0x0
    4fcc:	408080e7          	jalr	1032(ra) # 53d0 <close>
  unlink("junk");
    4fd0:	00002517          	auipc	a0,0x2
    4fd4:	59850513          	addi	a0,a0,1432 # 7568 <malloc+0x1d7a>
    4fd8:	00000097          	auipc	ra,0x0
    4fdc:	420080e7          	jalr	1056(ra) # 53f8 <unlink>
  exit(0);
    4fe0:	4501                	li	a0,0
    4fe2:	00000097          	auipc	ra,0x0
    4fe6:	3c6080e7          	jalr	966(ra) # 53a8 <exit>

0000000000004fea <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4fea:	7179                	addi	sp,sp,-48
    4fec:	f406                	sd	ra,40(sp)
    4fee:	f022                	sd	s0,32(sp)
    4ff0:	ec26                	sd	s1,24(sp)
    4ff2:	e84a                	sd	s2,16(sp)
    4ff4:	1800                	addi	s0,sp,48
    4ff6:	892a                	mv	s2,a0
    4ff8:	84ae                	mv	s1,a1
  int pid;
  int xstatus;
  
  printf("test %s: ", s);
    4ffa:	00002517          	auipc	a0,0x2
    4ffe:	59e50513          	addi	a0,a0,1438 # 7598 <malloc+0x1daa>
    5002:	00000097          	auipc	ra,0x0
    5006:	72e080e7          	jalr	1838(ra) # 5730 <printf>
  if((pid = fork()) < 0) {
    500a:	00000097          	auipc	ra,0x0
    500e:	396080e7          	jalr	918(ra) # 53a0 <fork>
    5012:	02054f63          	bltz	a0,5050 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5016:	c931                	beqz	a0,506a <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5018:	fdc40513          	addi	a0,s0,-36
    501c:	00000097          	auipc	ra,0x0
    5020:	394080e7          	jalr	916(ra) # 53b0 <wait>
    if(xstatus != 0) 
    5024:	fdc42783          	lw	a5,-36(s0)
    5028:	cba1                	beqz	a5,5078 <run+0x8e>
      printf("FAILED\n", s);
    502a:	85a6                	mv	a1,s1
    502c:	00002517          	auipc	a0,0x2
    5030:	59450513          	addi	a0,a0,1428 # 75c0 <malloc+0x1dd2>
    5034:	00000097          	auipc	ra,0x0
    5038:	6fc080e7          	jalr	1788(ra) # 5730 <printf>
    else
      printf("OK\n", s);
    return xstatus == 0;
    503c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5040:	00153513          	seqz	a0,a0
    5044:	70a2                	ld	ra,40(sp)
    5046:	7402                	ld	s0,32(sp)
    5048:	64e2                	ld	s1,24(sp)
    504a:	6942                	ld	s2,16(sp)
    504c:	6145                	addi	sp,sp,48
    504e:	8082                	ret
    printf("runtest: fork error\n");
    5050:	00002517          	auipc	a0,0x2
    5054:	55850513          	addi	a0,a0,1368 # 75a8 <malloc+0x1dba>
    5058:	00000097          	auipc	ra,0x0
    505c:	6d8080e7          	jalr	1752(ra) # 5730 <printf>
    exit(1);
    5060:	4505                	li	a0,1
    5062:	00000097          	auipc	ra,0x0
    5066:	346080e7          	jalr	838(ra) # 53a8 <exit>
    f(s);
    506a:	8526                	mv	a0,s1
    506c:	9902                	jalr	s2
    exit(0);
    506e:	4501                	li	a0,0
    5070:	00000097          	auipc	ra,0x0
    5074:	338080e7          	jalr	824(ra) # 53a8 <exit>
      printf("OK\n", s);
    5078:	85a6                	mv	a1,s1
    507a:	00002517          	auipc	a0,0x2
    507e:	54e50513          	addi	a0,a0,1358 # 75c8 <malloc+0x1dda>
    5082:	00000097          	auipc	ra,0x0
    5086:	6ae080e7          	jalr	1710(ra) # 5730 <printf>
    508a:	bf4d                	j	503c <run+0x52>

000000000000508c <main>:

int
main(int argc, char *argv[])
{
    508c:	ce010113          	addi	sp,sp,-800
    5090:	30113c23          	sd	ra,792(sp)
    5094:	30813823          	sd	s0,784(sp)
    5098:	30913423          	sd	s1,776(sp)
    509c:	31213023          	sd	s2,768(sp)
    50a0:	2f313c23          	sd	s3,760(sp)
    50a4:	2f413823          	sd	s4,752(sp)
    50a8:	1600                	addi	s0,sp,800
  char *n = 0;
  if(argc > 1) {
    50aa:	4785                	li	a5,1
  char *n = 0;
    50ac:	4901                	li	s2,0
  if(argc > 1) {
    50ae:	00a7d463          	bge	a5,a0,50b6 <main+0x2a>
    n = argv[1];
    50b2:	0085b903          	ld	s2,8(a1)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    50b6:	00002797          	auipc	a5,0x2
    50ba:	5ba78793          	addi	a5,a5,1466 # 7670 <malloc+0x1e82>
    50be:	ce040713          	addi	a4,s0,-800
    50c2:	00003817          	auipc	a6,0x3
    50c6:	88e80813          	addi	a6,a6,-1906 # 7950 <malloc+0x2162>
    50ca:	6388                	ld	a0,0(a5)
    50cc:	678c                	ld	a1,8(a5)
    50ce:	6b90                	ld	a2,16(a5)
    50d0:	6f94                	ld	a3,24(a5)
    50d2:	e308                	sd	a0,0(a4)
    50d4:	e70c                	sd	a1,8(a4)
    50d6:	eb10                	sd	a2,16(a4)
    50d8:	ef14                	sd	a3,24(a4)
    50da:	02078793          	addi	a5,a5,32
    50de:	02070713          	addi	a4,a4,32
    50e2:	ff0794e3          	bne	a5,a6,50ca <main+0x3e>
    50e6:	6394                	ld	a3,0(a5)
    50e8:	679c                	ld	a5,8(a5)
    50ea:	e314                	sd	a3,0(a4)
    50ec:	e71c                	sd	a5,8(a4)
    {forktest, "forktest"},
    {bigdir, "bigdir"}, // slow
    { 0, 0},
  };
    
  printf("usertests starting\n");
    50ee:	00002517          	auipc	a0,0x2
    50f2:	4e250513          	addi	a0,a0,1250 # 75d0 <malloc+0x1de2>
    50f6:	00000097          	auipc	ra,0x0
    50fa:	63a080e7          	jalr	1594(ra) # 5730 <printf>

  if(open("usertests.ran", 0) >= 0){
    50fe:	4581                	li	a1,0
    5100:	00002517          	auipc	a0,0x2
    5104:	4e850513          	addi	a0,a0,1256 # 75e8 <malloc+0x1dfa>
    5108:	00000097          	auipc	ra,0x0
    510c:	2e0080e7          	jalr	736(ra) # 53e8 <open>
    5110:	00054f63          	bltz	a0,512e <main+0xa2>
    printf("already ran user tests -- rebuild fs.img (rm fs.img; make fs.img)\n");
    5114:	00002517          	auipc	a0,0x2
    5118:	4e450513          	addi	a0,a0,1252 # 75f8 <malloc+0x1e0a>
    511c:	00000097          	auipc	ra,0x0
    5120:	614080e7          	jalr	1556(ra) # 5730 <printf>
    exit(1);
    5124:	4505                	li	a0,1
    5126:	00000097          	auipc	ra,0x0
    512a:	282080e7          	jalr	642(ra) # 53a8 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    512e:	20000593          	li	a1,512
    5132:	00002517          	auipc	a0,0x2
    5136:	4b650513          	addi	a0,a0,1206 # 75e8 <malloc+0x1dfa>
    513a:	00000097          	auipc	ra,0x0
    513e:	2ae080e7          	jalr	686(ra) # 53e8 <open>
    5142:	00000097          	auipc	ra,0x0
    5146:	28e080e7          	jalr	654(ra) # 53d0 <close>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    514a:	ce843503          	ld	a0,-792(s0)
    514e:	c529                	beqz	a0,5198 <main+0x10c>
    5150:	ce040493          	addi	s1,s0,-800
  int fail = 0;
    5154:	4981                	li	s3,0
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5156:	4a05                	li	s4,1
    5158:	a021                	j	5160 <main+0xd4>
  for (struct test *t = tests; t->s != 0; t++) {
    515a:	04c1                	addi	s1,s1,16
    515c:	6488                	ld	a0,8(s1)
    515e:	c115                	beqz	a0,5182 <main+0xf6>
    if((n == 0) || strcmp(t->s, n) == 0) {
    5160:	00090863          	beqz	s2,5170 <main+0xe4>
    5164:	85ca                	mv	a1,s2
    5166:	00000097          	auipc	ra,0x0
    516a:	068080e7          	jalr	104(ra) # 51ce <strcmp>
    516e:	f575                	bnez	a0,515a <main+0xce>
      if(!run(t->f, t->s))
    5170:	648c                	ld	a1,8(s1)
    5172:	6088                	ld	a0,0(s1)
    5174:	00000097          	auipc	ra,0x0
    5178:	e76080e7          	jalr	-394(ra) # 4fea <run>
    517c:	fd79                	bnez	a0,515a <main+0xce>
        fail = 1;
    517e:	89d2                	mv	s3,s4
    5180:	bfe9                	j	515a <main+0xce>
    }
  }
  if(!fail)
    5182:	00098b63          	beqz	s3,5198 <main+0x10c>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
    5186:	00002517          	auipc	a0,0x2
    518a:	4d250513          	addi	a0,a0,1234 # 7658 <malloc+0x1e6a>
    518e:	00000097          	auipc	ra,0x0
    5192:	5a2080e7          	jalr	1442(ra) # 5730 <printf>
    5196:	a809                	j	51a8 <main+0x11c>
    printf("ALL TESTS PASSED\n");
    5198:	00002517          	auipc	a0,0x2
    519c:	4a850513          	addi	a0,a0,1192 # 7640 <malloc+0x1e52>
    51a0:	00000097          	auipc	ra,0x0
    51a4:	590080e7          	jalr	1424(ra) # 5730 <printf>
  exit(1);   // not reached.
    51a8:	4505                	li	a0,1
    51aa:	00000097          	auipc	ra,0x0
    51ae:	1fe080e7          	jalr	510(ra) # 53a8 <exit>

00000000000051b2 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    51b2:	1141                	addi	sp,sp,-16
    51b4:	e422                	sd	s0,8(sp)
    51b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    51b8:	87aa                	mv	a5,a0
    51ba:	0585                	addi	a1,a1,1
    51bc:	0785                	addi	a5,a5,1
    51be:	fff5c703          	lbu	a4,-1(a1)
    51c2:	fee78fa3          	sb	a4,-1(a5)
    51c6:	fb75                	bnez	a4,51ba <strcpy+0x8>
    ;
  return os;
}
    51c8:	6422                	ld	s0,8(sp)
    51ca:	0141                	addi	sp,sp,16
    51cc:	8082                	ret

00000000000051ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
    51ce:	1141                	addi	sp,sp,-16
    51d0:	e422                	sd	s0,8(sp)
    51d2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    51d4:	00054783          	lbu	a5,0(a0)
    51d8:	cb91                	beqz	a5,51ec <strcmp+0x1e>
    51da:	0005c703          	lbu	a4,0(a1)
    51de:	00f71763          	bne	a4,a5,51ec <strcmp+0x1e>
    p++, q++;
    51e2:	0505                	addi	a0,a0,1
    51e4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    51e6:	00054783          	lbu	a5,0(a0)
    51ea:	fbe5                	bnez	a5,51da <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    51ec:	0005c503          	lbu	a0,0(a1)
}
    51f0:	40a7853b          	subw	a0,a5,a0
    51f4:	6422                	ld	s0,8(sp)
    51f6:	0141                	addi	sp,sp,16
    51f8:	8082                	ret

00000000000051fa <strlen>:

uint
strlen(const char *s)
{
    51fa:	1141                	addi	sp,sp,-16
    51fc:	e422                	sd	s0,8(sp)
    51fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5200:	00054783          	lbu	a5,0(a0)
    5204:	cf91                	beqz	a5,5220 <strlen+0x26>
    5206:	0505                	addi	a0,a0,1
    5208:	87aa                	mv	a5,a0
    520a:	4685                	li	a3,1
    520c:	9e89                	subw	a3,a3,a0
    520e:	00f6853b          	addw	a0,a3,a5
    5212:	0785                	addi	a5,a5,1
    5214:	fff7c703          	lbu	a4,-1(a5)
    5218:	fb7d                	bnez	a4,520e <strlen+0x14>
    ;
  return n;
}
    521a:	6422                	ld	s0,8(sp)
    521c:	0141                	addi	sp,sp,16
    521e:	8082                	ret
  for(n = 0; s[n]; n++)
    5220:	4501                	li	a0,0
    5222:	bfe5                	j	521a <strlen+0x20>

0000000000005224 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5224:	1141                	addi	sp,sp,-16
    5226:	e422                	sd	s0,8(sp)
    5228:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    522a:	ce09                	beqz	a2,5244 <memset+0x20>
    522c:	87aa                	mv	a5,a0
    522e:	fff6071b          	addiw	a4,a2,-1
    5232:	1702                	slli	a4,a4,0x20
    5234:	9301                	srli	a4,a4,0x20
    5236:	0705                	addi	a4,a4,1
    5238:	972a                	add	a4,a4,a0
    cdst[i] = c;
    523a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    523e:	0785                	addi	a5,a5,1
    5240:	fee79de3          	bne	a5,a4,523a <memset+0x16>
  }
  return dst;
}
    5244:	6422                	ld	s0,8(sp)
    5246:	0141                	addi	sp,sp,16
    5248:	8082                	ret

000000000000524a <strchr>:

char*
strchr(const char *s, char c)
{
    524a:	1141                	addi	sp,sp,-16
    524c:	e422                	sd	s0,8(sp)
    524e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5250:	00054783          	lbu	a5,0(a0)
    5254:	cb99                	beqz	a5,526a <strchr+0x20>
    if(*s == c)
    5256:	00f58763          	beq	a1,a5,5264 <strchr+0x1a>
  for(; *s; s++)
    525a:	0505                	addi	a0,a0,1
    525c:	00054783          	lbu	a5,0(a0)
    5260:	fbfd                	bnez	a5,5256 <strchr+0xc>
      return (char*)s;
  return 0;
    5262:	4501                	li	a0,0
}
    5264:	6422                	ld	s0,8(sp)
    5266:	0141                	addi	sp,sp,16
    5268:	8082                	ret
  return 0;
    526a:	4501                	li	a0,0
    526c:	bfe5                	j	5264 <strchr+0x1a>

000000000000526e <gets>:

char*
gets(char *buf, int max)
{
    526e:	711d                	addi	sp,sp,-96
    5270:	ec86                	sd	ra,88(sp)
    5272:	e8a2                	sd	s0,80(sp)
    5274:	e4a6                	sd	s1,72(sp)
    5276:	e0ca                	sd	s2,64(sp)
    5278:	fc4e                	sd	s3,56(sp)
    527a:	f852                	sd	s4,48(sp)
    527c:	f456                	sd	s5,40(sp)
    527e:	f05a                	sd	s6,32(sp)
    5280:	ec5e                	sd	s7,24(sp)
    5282:	1080                	addi	s0,sp,96
    5284:	8baa                	mv	s7,a0
    5286:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5288:	892a                	mv	s2,a0
    528a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    528c:	4aa9                	li	s5,10
    528e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5290:	89a6                	mv	s3,s1
    5292:	2485                	addiw	s1,s1,1
    5294:	0344d863          	bge	s1,s4,52c4 <gets+0x56>
    cc = read(0, &c, 1);
    5298:	4605                	li	a2,1
    529a:	faf40593          	addi	a1,s0,-81
    529e:	4501                	li	a0,0
    52a0:	00000097          	auipc	ra,0x0
    52a4:	120080e7          	jalr	288(ra) # 53c0 <read>
    if(cc < 1)
    52a8:	00a05e63          	blez	a0,52c4 <gets+0x56>
    buf[i++] = c;
    52ac:	faf44783          	lbu	a5,-81(s0)
    52b0:	00f90023          	sb	a5,0(s2) # 3000 <fourfiles+0x208>
    if(c == '\n' || c == '\r')
    52b4:	01578763          	beq	a5,s5,52c2 <gets+0x54>
    52b8:	0905                	addi	s2,s2,1
    52ba:	fd679be3          	bne	a5,s6,5290 <gets+0x22>
  for(i=0; i+1 < max; ){
    52be:	89a6                	mv	s3,s1
    52c0:	a011                	j	52c4 <gets+0x56>
    52c2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    52c4:	99de                	add	s3,s3,s7
    52c6:	00098023          	sb	zero,0(s3)
  return buf;
}
    52ca:	855e                	mv	a0,s7
    52cc:	60e6                	ld	ra,88(sp)
    52ce:	6446                	ld	s0,80(sp)
    52d0:	64a6                	ld	s1,72(sp)
    52d2:	6906                	ld	s2,64(sp)
    52d4:	79e2                	ld	s3,56(sp)
    52d6:	7a42                	ld	s4,48(sp)
    52d8:	7aa2                	ld	s5,40(sp)
    52da:	7b02                	ld	s6,32(sp)
    52dc:	6be2                	ld	s7,24(sp)
    52de:	6125                	addi	sp,sp,96
    52e0:	8082                	ret

00000000000052e2 <stat>:

int
stat(const char *n, struct stat *st)
{
    52e2:	1101                	addi	sp,sp,-32
    52e4:	ec06                	sd	ra,24(sp)
    52e6:	e822                	sd	s0,16(sp)
    52e8:	e426                	sd	s1,8(sp)
    52ea:	e04a                	sd	s2,0(sp)
    52ec:	1000                	addi	s0,sp,32
    52ee:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    52f0:	4581                	li	a1,0
    52f2:	00000097          	auipc	ra,0x0
    52f6:	0f6080e7          	jalr	246(ra) # 53e8 <open>
  if(fd < 0)
    52fa:	02054563          	bltz	a0,5324 <stat+0x42>
    52fe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5300:	85ca                	mv	a1,s2
    5302:	00000097          	auipc	ra,0x0
    5306:	0fe080e7          	jalr	254(ra) # 5400 <fstat>
    530a:	892a                	mv	s2,a0
  close(fd);
    530c:	8526                	mv	a0,s1
    530e:	00000097          	auipc	ra,0x0
    5312:	0c2080e7          	jalr	194(ra) # 53d0 <close>
  return r;
}
    5316:	854a                	mv	a0,s2
    5318:	60e2                	ld	ra,24(sp)
    531a:	6442                	ld	s0,16(sp)
    531c:	64a2                	ld	s1,8(sp)
    531e:	6902                	ld	s2,0(sp)
    5320:	6105                	addi	sp,sp,32
    5322:	8082                	ret
    return -1;
    5324:	597d                	li	s2,-1
    5326:	bfc5                	j	5316 <stat+0x34>

0000000000005328 <atoi>:

int
atoi(const char *s)
{
    5328:	1141                	addi	sp,sp,-16
    532a:	e422                	sd	s0,8(sp)
    532c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    532e:	00054603          	lbu	a2,0(a0)
    5332:	fd06079b          	addiw	a5,a2,-48
    5336:	0ff7f793          	andi	a5,a5,255
    533a:	4725                	li	a4,9
    533c:	02f76963          	bltu	a4,a5,536e <atoi+0x46>
    5340:	86aa                	mv	a3,a0
  n = 0;
    5342:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5344:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5346:	0685                	addi	a3,a3,1
    5348:	0025179b          	slliw	a5,a0,0x2
    534c:	9fa9                	addw	a5,a5,a0
    534e:	0017979b          	slliw	a5,a5,0x1
    5352:	9fb1                	addw	a5,a5,a2
    5354:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5358:	0006c603          	lbu	a2,0(a3) # 1000 <bsstest>
    535c:	fd06071b          	addiw	a4,a2,-48
    5360:	0ff77713          	andi	a4,a4,255
    5364:	fee5f1e3          	bgeu	a1,a4,5346 <atoi+0x1e>
  return n;
}
    5368:	6422                	ld	s0,8(sp)
    536a:	0141                	addi	sp,sp,16
    536c:	8082                	ret
  n = 0;
    536e:	4501                	li	a0,0
    5370:	bfe5                	j	5368 <atoi+0x40>

0000000000005372 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5372:	1141                	addi	sp,sp,-16
    5374:	e422                	sd	s0,8(sp)
    5376:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    5378:	02c05163          	blez	a2,539a <memmove+0x28>
    537c:	fff6071b          	addiw	a4,a2,-1
    5380:	1702                	slli	a4,a4,0x20
    5382:	9301                	srli	a4,a4,0x20
    5384:	0705                	addi	a4,a4,1
    5386:	972a                	add	a4,a4,a0
  dst = vdst;
    5388:	87aa                	mv	a5,a0
    *dst++ = *src++;
    538a:	0585                	addi	a1,a1,1
    538c:	0785                	addi	a5,a5,1
    538e:	fff5c683          	lbu	a3,-1(a1)
    5392:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    5396:	fee79ae3          	bne	a5,a4,538a <memmove+0x18>
  return vdst;
}
    539a:	6422                	ld	s0,8(sp)
    539c:	0141                	addi	sp,sp,16
    539e:	8082                	ret

00000000000053a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    53a0:	4885                	li	a7,1
 ecall
    53a2:	00000073          	ecall
 ret
    53a6:	8082                	ret

00000000000053a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
    53a8:	4889                	li	a7,2
 ecall
    53aa:	00000073          	ecall
 ret
    53ae:	8082                	ret

00000000000053b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
    53b0:	488d                	li	a7,3
 ecall
    53b2:	00000073          	ecall
 ret
    53b6:	8082                	ret

00000000000053b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    53b8:	4891                	li	a7,4
 ecall
    53ba:	00000073          	ecall
 ret
    53be:	8082                	ret

00000000000053c0 <read>:
.global read
read:
 li a7, SYS_read
    53c0:	4895                	li	a7,5
 ecall
    53c2:	00000073          	ecall
 ret
    53c6:	8082                	ret

00000000000053c8 <write>:
.global write
write:
 li a7, SYS_write
    53c8:	48c1                	li	a7,16
 ecall
    53ca:	00000073          	ecall
 ret
    53ce:	8082                	ret

00000000000053d0 <close>:
.global close
close:
 li a7, SYS_close
    53d0:	48d5                	li	a7,21
 ecall
    53d2:	00000073          	ecall
 ret
    53d6:	8082                	ret

00000000000053d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
    53d8:	4899                	li	a7,6
 ecall
    53da:	00000073          	ecall
 ret
    53de:	8082                	ret

00000000000053e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
    53e0:	489d                	li	a7,7
 ecall
    53e2:	00000073          	ecall
 ret
    53e6:	8082                	ret

00000000000053e8 <open>:
.global open
open:
 li a7, SYS_open
    53e8:	48bd                	li	a7,15
 ecall
    53ea:	00000073          	ecall
 ret
    53ee:	8082                	ret

00000000000053f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    53f0:	48c5                	li	a7,17
 ecall
    53f2:	00000073          	ecall
 ret
    53f6:	8082                	ret

00000000000053f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    53f8:	48c9                	li	a7,18
 ecall
    53fa:	00000073          	ecall
 ret
    53fe:	8082                	ret

0000000000005400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5400:	48a1                	li	a7,8
 ecall
    5402:	00000073          	ecall
 ret
    5406:	8082                	ret

0000000000005408 <link>:
.global link
link:
 li a7, SYS_link
    5408:	48cd                	li	a7,19
 ecall
    540a:	00000073          	ecall
 ret
    540e:	8082                	ret

0000000000005410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5410:	48d1                	li	a7,20
 ecall
    5412:	00000073          	ecall
 ret
    5416:	8082                	ret

0000000000005418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5418:	48a5                	li	a7,9
 ecall
    541a:	00000073          	ecall
 ret
    541e:	8082                	ret

0000000000005420 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5420:	48a9                	li	a7,10
 ecall
    5422:	00000073          	ecall
 ret
    5426:	8082                	ret

0000000000005428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5428:	48ad                	li	a7,11
 ecall
    542a:	00000073          	ecall
 ret
    542e:	8082                	ret

0000000000005430 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5430:	48b1                	li	a7,12
 ecall
    5432:	00000073          	ecall
 ret
    5436:	8082                	ret

0000000000005438 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5438:	48b5                	li	a7,13
 ecall
    543a:	00000073          	ecall
 ret
    543e:	8082                	ret

0000000000005440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5440:	48b9                	li	a7,14
 ecall
    5442:	00000073          	ecall
 ret
    5446:	8082                	ret

0000000000005448 <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    5448:	48d9                	li	a7,22
 ecall
    544a:	00000073          	ecall
 ret
    544e:	8082                	ret

0000000000005450 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    5450:	48dd                	li	a7,23
 ecall
    5452:	00000073          	ecall
 ret
    5456:	8082                	ret

0000000000005458 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5458:	1101                	addi	sp,sp,-32
    545a:	ec06                	sd	ra,24(sp)
    545c:	e822                	sd	s0,16(sp)
    545e:	1000                	addi	s0,sp,32
    5460:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5464:	4605                	li	a2,1
    5466:	fef40593          	addi	a1,s0,-17
    546a:	00000097          	auipc	ra,0x0
    546e:	f5e080e7          	jalr	-162(ra) # 53c8 <write>
}
    5472:	60e2                	ld	ra,24(sp)
    5474:	6442                	ld	s0,16(sp)
    5476:	6105                	addi	sp,sp,32
    5478:	8082                	ret

000000000000547a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    547a:	7139                	addi	sp,sp,-64
    547c:	fc06                	sd	ra,56(sp)
    547e:	f822                	sd	s0,48(sp)
    5480:	f426                	sd	s1,40(sp)
    5482:	f04a                	sd	s2,32(sp)
    5484:	ec4e                	sd	s3,24(sp)
    5486:	0080                	addi	s0,sp,64
    5488:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    548a:	c299                	beqz	a3,5490 <printint+0x16>
    548c:	0805c863          	bltz	a1,551c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5490:	2581                	sext.w	a1,a1
  neg = 0;
    5492:	4881                	li	a7,0
    5494:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5498:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    549a:	2601                	sext.w	a2,a2
    549c:	00002517          	auipc	a0,0x2
    54a0:	4cc50513          	addi	a0,a0,1228 # 7968 <digits>
    54a4:	883a                	mv	a6,a4
    54a6:	2705                	addiw	a4,a4,1
    54a8:	02c5f7bb          	remuw	a5,a1,a2
    54ac:	1782                	slli	a5,a5,0x20
    54ae:	9381                	srli	a5,a5,0x20
    54b0:	97aa                	add	a5,a5,a0
    54b2:	0007c783          	lbu	a5,0(a5)
    54b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    54ba:	0005879b          	sext.w	a5,a1
    54be:	02c5d5bb          	divuw	a1,a1,a2
    54c2:	0685                	addi	a3,a3,1
    54c4:	fec7f0e3          	bgeu	a5,a2,54a4 <printint+0x2a>
  if(neg)
    54c8:	00088b63          	beqz	a7,54de <printint+0x64>
    buf[i++] = '-';
    54cc:	fd040793          	addi	a5,s0,-48
    54d0:	973e                	add	a4,a4,a5
    54d2:	02d00793          	li	a5,45
    54d6:	fef70823          	sb	a5,-16(a4)
    54da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    54de:	02e05863          	blez	a4,550e <printint+0x94>
    54e2:	fc040793          	addi	a5,s0,-64
    54e6:	00e78933          	add	s2,a5,a4
    54ea:	fff78993          	addi	s3,a5,-1
    54ee:	99ba                	add	s3,s3,a4
    54f0:	377d                	addiw	a4,a4,-1
    54f2:	1702                	slli	a4,a4,0x20
    54f4:	9301                	srli	a4,a4,0x20
    54f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    54fa:	fff94583          	lbu	a1,-1(s2)
    54fe:	8526                	mv	a0,s1
    5500:	00000097          	auipc	ra,0x0
    5504:	f58080e7          	jalr	-168(ra) # 5458 <putc>
  while(--i >= 0)
    5508:	197d                	addi	s2,s2,-1
    550a:	ff3918e3          	bne	s2,s3,54fa <printint+0x80>
}
    550e:	70e2                	ld	ra,56(sp)
    5510:	7442                	ld	s0,48(sp)
    5512:	74a2                	ld	s1,40(sp)
    5514:	7902                	ld	s2,32(sp)
    5516:	69e2                	ld	s3,24(sp)
    5518:	6121                	addi	sp,sp,64
    551a:	8082                	ret
    x = -xx;
    551c:	40b005bb          	negw	a1,a1
    neg = 1;
    5520:	4885                	li	a7,1
    x = -xx;
    5522:	bf8d                	j	5494 <printint+0x1a>

0000000000005524 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5524:	7119                	addi	sp,sp,-128
    5526:	fc86                	sd	ra,120(sp)
    5528:	f8a2                	sd	s0,112(sp)
    552a:	f4a6                	sd	s1,104(sp)
    552c:	f0ca                	sd	s2,96(sp)
    552e:	ecce                	sd	s3,88(sp)
    5530:	e8d2                	sd	s4,80(sp)
    5532:	e4d6                	sd	s5,72(sp)
    5534:	e0da                	sd	s6,64(sp)
    5536:	fc5e                	sd	s7,56(sp)
    5538:	f862                	sd	s8,48(sp)
    553a:	f466                	sd	s9,40(sp)
    553c:	f06a                	sd	s10,32(sp)
    553e:	ec6e                	sd	s11,24(sp)
    5540:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5542:	0005c903          	lbu	s2,0(a1)
    5546:	18090f63          	beqz	s2,56e4 <vprintf+0x1c0>
    554a:	8aaa                	mv	s5,a0
    554c:	8b32                	mv	s6,a2
    554e:	00158493          	addi	s1,a1,1
  state = 0;
    5552:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5554:	02500a13          	li	s4,37
      if(c == 'd'){
    5558:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    555c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5560:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5564:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5568:	00002b97          	auipc	s7,0x2
    556c:	400b8b93          	addi	s7,s7,1024 # 7968 <digits>
    5570:	a839                	j	558e <vprintf+0x6a>
        putc(fd, c);
    5572:	85ca                	mv	a1,s2
    5574:	8556                	mv	a0,s5
    5576:	00000097          	auipc	ra,0x0
    557a:	ee2080e7          	jalr	-286(ra) # 5458 <putc>
    557e:	a019                	j	5584 <vprintf+0x60>
    } else if(state == '%'){
    5580:	01498f63          	beq	s3,s4,559e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5584:	0485                	addi	s1,s1,1
    5586:	fff4c903          	lbu	s2,-1(s1)
    558a:	14090d63          	beqz	s2,56e4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    558e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5592:	fe0997e3          	bnez	s3,5580 <vprintf+0x5c>
      if(c == '%'){
    5596:	fd479ee3          	bne	a5,s4,5572 <vprintf+0x4e>
        state = '%';
    559a:	89be                	mv	s3,a5
    559c:	b7e5                	j	5584 <vprintf+0x60>
      if(c == 'd'){
    559e:	05878063          	beq	a5,s8,55de <vprintf+0xba>
      } else if(c == 'l') {
    55a2:	05978c63          	beq	a5,s9,55fa <vprintf+0xd6>
      } else if(c == 'x') {
    55a6:	07a78863          	beq	a5,s10,5616 <vprintf+0xf2>
      } else if(c == 'p') {
    55aa:	09b78463          	beq	a5,s11,5632 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    55ae:	07300713          	li	a4,115
    55b2:	0ce78663          	beq	a5,a4,567e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    55b6:	06300713          	li	a4,99
    55ba:	0ee78e63          	beq	a5,a4,56b6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    55be:	11478863          	beq	a5,s4,56ce <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    55c2:	85d2                	mv	a1,s4
    55c4:	8556                	mv	a0,s5
    55c6:	00000097          	auipc	ra,0x0
    55ca:	e92080e7          	jalr	-366(ra) # 5458 <putc>
        putc(fd, c);
    55ce:	85ca                	mv	a1,s2
    55d0:	8556                	mv	a0,s5
    55d2:	00000097          	auipc	ra,0x0
    55d6:	e86080e7          	jalr	-378(ra) # 5458 <putc>
      }
      state = 0;
    55da:	4981                	li	s3,0
    55dc:	b765                	j	5584 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    55de:	008b0913          	addi	s2,s6,8
    55e2:	4685                	li	a3,1
    55e4:	4629                	li	a2,10
    55e6:	000b2583          	lw	a1,0(s6)
    55ea:	8556                	mv	a0,s5
    55ec:	00000097          	auipc	ra,0x0
    55f0:	e8e080e7          	jalr	-370(ra) # 547a <printint>
    55f4:	8b4a                	mv	s6,s2
      state = 0;
    55f6:	4981                	li	s3,0
    55f8:	b771                	j	5584 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    55fa:	008b0913          	addi	s2,s6,8
    55fe:	4681                	li	a3,0
    5600:	4629                	li	a2,10
    5602:	000b2583          	lw	a1,0(s6)
    5606:	8556                	mv	a0,s5
    5608:	00000097          	auipc	ra,0x0
    560c:	e72080e7          	jalr	-398(ra) # 547a <printint>
    5610:	8b4a                	mv	s6,s2
      state = 0;
    5612:	4981                	li	s3,0
    5614:	bf85                	j	5584 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5616:	008b0913          	addi	s2,s6,8
    561a:	4681                	li	a3,0
    561c:	4641                	li	a2,16
    561e:	000b2583          	lw	a1,0(s6)
    5622:	8556                	mv	a0,s5
    5624:	00000097          	auipc	ra,0x0
    5628:	e56080e7          	jalr	-426(ra) # 547a <printint>
    562c:	8b4a                	mv	s6,s2
      state = 0;
    562e:	4981                	li	s3,0
    5630:	bf91                	j	5584 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5632:	008b0793          	addi	a5,s6,8
    5636:	f8f43423          	sd	a5,-120(s0)
    563a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    563e:	03000593          	li	a1,48
    5642:	8556                	mv	a0,s5
    5644:	00000097          	auipc	ra,0x0
    5648:	e14080e7          	jalr	-492(ra) # 5458 <putc>
  putc(fd, 'x');
    564c:	85ea                	mv	a1,s10
    564e:	8556                	mv	a0,s5
    5650:	00000097          	auipc	ra,0x0
    5654:	e08080e7          	jalr	-504(ra) # 5458 <putc>
    5658:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    565a:	03c9d793          	srli	a5,s3,0x3c
    565e:	97de                	add	a5,a5,s7
    5660:	0007c583          	lbu	a1,0(a5)
    5664:	8556                	mv	a0,s5
    5666:	00000097          	auipc	ra,0x0
    566a:	df2080e7          	jalr	-526(ra) # 5458 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    566e:	0992                	slli	s3,s3,0x4
    5670:	397d                	addiw	s2,s2,-1
    5672:	fe0914e3          	bnez	s2,565a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5676:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    567a:	4981                	li	s3,0
    567c:	b721                	j	5584 <vprintf+0x60>
        s = va_arg(ap, char*);
    567e:	008b0993          	addi	s3,s6,8
    5682:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5686:	02090163          	beqz	s2,56a8 <vprintf+0x184>
        while(*s != 0){
    568a:	00094583          	lbu	a1,0(s2)
    568e:	c9a1                	beqz	a1,56de <vprintf+0x1ba>
          putc(fd, *s);
    5690:	8556                	mv	a0,s5
    5692:	00000097          	auipc	ra,0x0
    5696:	dc6080e7          	jalr	-570(ra) # 5458 <putc>
          s++;
    569a:	0905                	addi	s2,s2,1
        while(*s != 0){
    569c:	00094583          	lbu	a1,0(s2)
    56a0:	f9e5                	bnez	a1,5690 <vprintf+0x16c>
        s = va_arg(ap, char*);
    56a2:	8b4e                	mv	s6,s3
      state = 0;
    56a4:	4981                	li	s3,0
    56a6:	bdf9                	j	5584 <vprintf+0x60>
          s = "(null)";
    56a8:	00002917          	auipc	s2,0x2
    56ac:	2b890913          	addi	s2,s2,696 # 7960 <malloc+0x2172>
        while(*s != 0){
    56b0:	02800593          	li	a1,40
    56b4:	bff1                	j	5690 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    56b6:	008b0913          	addi	s2,s6,8
    56ba:	000b4583          	lbu	a1,0(s6)
    56be:	8556                	mv	a0,s5
    56c0:	00000097          	auipc	ra,0x0
    56c4:	d98080e7          	jalr	-616(ra) # 5458 <putc>
    56c8:	8b4a                	mv	s6,s2
      state = 0;
    56ca:	4981                	li	s3,0
    56cc:	bd65                	j	5584 <vprintf+0x60>
        putc(fd, c);
    56ce:	85d2                	mv	a1,s4
    56d0:	8556                	mv	a0,s5
    56d2:	00000097          	auipc	ra,0x0
    56d6:	d86080e7          	jalr	-634(ra) # 5458 <putc>
      state = 0;
    56da:	4981                	li	s3,0
    56dc:	b565                	j	5584 <vprintf+0x60>
        s = va_arg(ap, char*);
    56de:	8b4e                	mv	s6,s3
      state = 0;
    56e0:	4981                	li	s3,0
    56e2:	b54d                	j	5584 <vprintf+0x60>
    }
  }
}
    56e4:	70e6                	ld	ra,120(sp)
    56e6:	7446                	ld	s0,112(sp)
    56e8:	74a6                	ld	s1,104(sp)
    56ea:	7906                	ld	s2,96(sp)
    56ec:	69e6                	ld	s3,88(sp)
    56ee:	6a46                	ld	s4,80(sp)
    56f0:	6aa6                	ld	s5,72(sp)
    56f2:	6b06                	ld	s6,64(sp)
    56f4:	7be2                	ld	s7,56(sp)
    56f6:	7c42                	ld	s8,48(sp)
    56f8:	7ca2                	ld	s9,40(sp)
    56fa:	7d02                	ld	s10,32(sp)
    56fc:	6de2                	ld	s11,24(sp)
    56fe:	6109                	addi	sp,sp,128
    5700:	8082                	ret

0000000000005702 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5702:	715d                	addi	sp,sp,-80
    5704:	ec06                	sd	ra,24(sp)
    5706:	e822                	sd	s0,16(sp)
    5708:	1000                	addi	s0,sp,32
    570a:	e010                	sd	a2,0(s0)
    570c:	e414                	sd	a3,8(s0)
    570e:	e818                	sd	a4,16(s0)
    5710:	ec1c                	sd	a5,24(s0)
    5712:	03043023          	sd	a6,32(s0)
    5716:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    571a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    571e:	8622                	mv	a2,s0
    5720:	00000097          	auipc	ra,0x0
    5724:	e04080e7          	jalr	-508(ra) # 5524 <vprintf>
}
    5728:	60e2                	ld	ra,24(sp)
    572a:	6442                	ld	s0,16(sp)
    572c:	6161                	addi	sp,sp,80
    572e:	8082                	ret

0000000000005730 <printf>:

void
printf(const char *fmt, ...)
{
    5730:	711d                	addi	sp,sp,-96
    5732:	ec06                	sd	ra,24(sp)
    5734:	e822                	sd	s0,16(sp)
    5736:	1000                	addi	s0,sp,32
    5738:	e40c                	sd	a1,8(s0)
    573a:	e810                	sd	a2,16(s0)
    573c:	ec14                	sd	a3,24(s0)
    573e:	f018                	sd	a4,32(s0)
    5740:	f41c                	sd	a5,40(s0)
    5742:	03043823          	sd	a6,48(s0)
    5746:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    574a:	00840613          	addi	a2,s0,8
    574e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5752:	85aa                	mv	a1,a0
    5754:	4505                	li	a0,1
    5756:	00000097          	auipc	ra,0x0
    575a:	dce080e7          	jalr	-562(ra) # 5524 <vprintf>
}
    575e:	60e2                	ld	ra,24(sp)
    5760:	6442                	ld	s0,16(sp)
    5762:	6125                	addi	sp,sp,96
    5764:	8082                	ret

0000000000005766 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5766:	1141                	addi	sp,sp,-16
    5768:	e422                	sd	s0,8(sp)
    576a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    576c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5770:	00002797          	auipc	a5,0x2
    5774:	2287b783          	ld	a5,552(a5) # 7998 <freep>
    5778:	a805                	j	57a8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    577a:	4618                	lw	a4,8(a2)
    577c:	9db9                	addw	a1,a1,a4
    577e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5782:	6398                	ld	a4,0(a5)
    5784:	6318                	ld	a4,0(a4)
    5786:	fee53823          	sd	a4,-16(a0)
    578a:	a091                	j	57ce <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    578c:	ff852703          	lw	a4,-8(a0)
    5790:	9e39                	addw	a2,a2,a4
    5792:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5794:	ff053703          	ld	a4,-16(a0)
    5798:	e398                	sd	a4,0(a5)
    579a:	a099                	j	57e0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    579c:	6398                	ld	a4,0(a5)
    579e:	00e7e463          	bltu	a5,a4,57a6 <free+0x40>
    57a2:	00e6ea63          	bltu	a3,a4,57b6 <free+0x50>
{
    57a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    57a8:	fed7fae3          	bgeu	a5,a3,579c <free+0x36>
    57ac:	6398                	ld	a4,0(a5)
    57ae:	00e6e463          	bltu	a3,a4,57b6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    57b2:	fee7eae3          	bltu	a5,a4,57a6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    57b6:	ff852583          	lw	a1,-8(a0)
    57ba:	6390                	ld	a2,0(a5)
    57bc:	02059713          	slli	a4,a1,0x20
    57c0:	9301                	srli	a4,a4,0x20
    57c2:	0712                	slli	a4,a4,0x4
    57c4:	9736                	add	a4,a4,a3
    57c6:	fae60ae3          	beq	a2,a4,577a <free+0x14>
    bp->s.ptr = p->s.ptr;
    57ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    57ce:	4790                	lw	a2,8(a5)
    57d0:	02061713          	slli	a4,a2,0x20
    57d4:	9301                	srli	a4,a4,0x20
    57d6:	0712                	slli	a4,a4,0x4
    57d8:	973e                	add	a4,a4,a5
    57da:	fae689e3          	beq	a3,a4,578c <free+0x26>
  } else
    p->s.ptr = bp;
    57de:	e394                	sd	a3,0(a5)
  freep = p;
    57e0:	00002717          	auipc	a4,0x2
    57e4:	1af73c23          	sd	a5,440(a4) # 7998 <freep>
}
    57e8:	6422                	ld	s0,8(sp)
    57ea:	0141                	addi	sp,sp,16
    57ec:	8082                	ret

00000000000057ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    57ee:	7139                	addi	sp,sp,-64
    57f0:	fc06                	sd	ra,56(sp)
    57f2:	f822                	sd	s0,48(sp)
    57f4:	f426                	sd	s1,40(sp)
    57f6:	f04a                	sd	s2,32(sp)
    57f8:	ec4e                	sd	s3,24(sp)
    57fa:	e852                	sd	s4,16(sp)
    57fc:	e456                	sd	s5,8(sp)
    57fe:	e05a                	sd	s6,0(sp)
    5800:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5802:	02051493          	slli	s1,a0,0x20
    5806:	9081                	srli	s1,s1,0x20
    5808:	04bd                	addi	s1,s1,15
    580a:	8091                	srli	s1,s1,0x4
    580c:	0014899b          	addiw	s3,s1,1
    5810:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5812:	00002517          	auipc	a0,0x2
    5816:	18653503          	ld	a0,390(a0) # 7998 <freep>
    581a:	c515                	beqz	a0,5846 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    581c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    581e:	4798                	lw	a4,8(a5)
    5820:	02977f63          	bgeu	a4,s1,585e <malloc+0x70>
    5824:	8a4e                	mv	s4,s3
    5826:	0009871b          	sext.w	a4,s3
    582a:	6685                	lui	a3,0x1
    582c:	00d77363          	bgeu	a4,a3,5832 <malloc+0x44>
    5830:	6a05                	lui	s4,0x1
    5832:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5836:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    583a:	00002917          	auipc	s2,0x2
    583e:	15e90913          	addi	s2,s2,350 # 7998 <freep>
  if(p == (char*)-1)
    5842:	5afd                	li	s5,-1
    5844:	a88d                	j	58b6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5846:	00008797          	auipc	a5,0x8
    584a:	96a78793          	addi	a5,a5,-1686 # d1b0 <base>
    584e:	00002717          	auipc	a4,0x2
    5852:	14f73523          	sd	a5,330(a4) # 7998 <freep>
    5856:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5858:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    585c:	b7e1                	j	5824 <malloc+0x36>
      if(p->s.size == nunits)
    585e:	02e48b63          	beq	s1,a4,5894 <malloc+0xa6>
        p->s.size -= nunits;
    5862:	4137073b          	subw	a4,a4,s3
    5866:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5868:	1702                	slli	a4,a4,0x20
    586a:	9301                	srli	a4,a4,0x20
    586c:	0712                	slli	a4,a4,0x4
    586e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5870:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5874:	00002717          	auipc	a4,0x2
    5878:	12a73223          	sd	a0,292(a4) # 7998 <freep>
      return (void*)(p + 1);
    587c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5880:	70e2                	ld	ra,56(sp)
    5882:	7442                	ld	s0,48(sp)
    5884:	74a2                	ld	s1,40(sp)
    5886:	7902                	ld	s2,32(sp)
    5888:	69e2                	ld	s3,24(sp)
    588a:	6a42                	ld	s4,16(sp)
    588c:	6aa2                	ld	s5,8(sp)
    588e:	6b02                	ld	s6,0(sp)
    5890:	6121                	addi	sp,sp,64
    5892:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5894:	6398                	ld	a4,0(a5)
    5896:	e118                	sd	a4,0(a0)
    5898:	bff1                	j	5874 <malloc+0x86>
  hp->s.size = nu;
    589a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    589e:	0541                	addi	a0,a0,16
    58a0:	00000097          	auipc	ra,0x0
    58a4:	ec6080e7          	jalr	-314(ra) # 5766 <free>
  return freep;
    58a8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    58ac:	d971                	beqz	a0,5880 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    58ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    58b0:	4798                	lw	a4,8(a5)
    58b2:	fa9776e3          	bgeu	a4,s1,585e <malloc+0x70>
    if(p == freep)
    58b6:	00093703          	ld	a4,0(s2)
    58ba:	853e                	mv	a0,a5
    58bc:	fef719e3          	bne	a4,a5,58ae <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    58c0:	8552                	mv	a0,s4
    58c2:	00000097          	auipc	ra,0x0
    58c6:	b6e080e7          	jalr	-1170(ra) # 5430 <sbrk>
  if(p == (char*)-1)
    58ca:	fd5518e3          	bne	a0,s5,589a <malloc+0xac>
        return 0;
    58ce:	4501                	li	a0,0
    58d0:	bf45                	j	5880 <malloc+0x92>
