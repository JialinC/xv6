
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
    1000:	1101                	addi	sp,sp,-32
    1002:	ec06                	sd	ra,24(sp)
    1004:	e822                	sd	s0,16(sp)
    1006:	e426                	sd	s1,8(sp)
    1008:	e04a                	sd	s2,0(sp)
    100a:	1000                	addi	s0,sp,32
    100c:	84aa                	mv	s1,a0
    100e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
    1010:	00001597          	auipc	a1,0x1
    1014:	26858593          	addi	a1,a1,616 # 2278 <malloc+0xe8>
    1018:	4509                	li	a0,2
    101a:	00001097          	auipc	ra,0x1
    101e:	08a080e7          	jalr	138(ra) # 20a4 <fprintf>
  memset(buf, 0, nbuf);
    1022:	864a                	mv	a2,s2
    1024:	4581                	li	a1,0
    1026:	8526                	mv	a0,s1
    1028:	00001097          	auipc	ra,0x1
    102c:	b9e080e7          	jalr	-1122(ra) # 1bc6 <memset>
  gets(buf, nbuf);
    1030:	85ca                	mv	a1,s2
    1032:	8526                	mv	a0,s1
    1034:	00001097          	auipc	ra,0x1
    1038:	bdc080e7          	jalr	-1060(ra) # 1c10 <gets>
  if(buf[0] == 0) // EOF
    103c:	0004c503          	lbu	a0,0(s1)
    1040:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
    1044:	40a00533          	neg	a0,a0
    1048:	60e2                	ld	ra,24(sp)
    104a:	6442                	ld	s0,16(sp)
    104c:	64a2                	ld	s1,8(sp)
    104e:	6902                	ld	s2,0(sp)
    1050:	6105                	addi	sp,sp,32
    1052:	8082                	ret

0000000000001054 <panic>:
  exit(0);
}

void
panic(char *s)
{
    1054:	1141                	addi	sp,sp,-16
    1056:	e406                	sd	ra,8(sp)
    1058:	e022                	sd	s0,0(sp)
    105a:	0800                	addi	s0,sp,16
    105c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
    105e:	00001597          	auipc	a1,0x1
    1062:	22258593          	addi	a1,a1,546 # 2280 <malloc+0xf0>
    1066:	4509                	li	a0,2
    1068:	00001097          	auipc	ra,0x1
    106c:	03c080e7          	jalr	60(ra) # 20a4 <fprintf>
  exit(1);
    1070:	4505                	li	a0,1
    1072:	00001097          	auipc	ra,0x1
    1076:	cd8080e7          	jalr	-808(ra) # 1d4a <exit>

000000000000107a <fork1>:
}

int
fork1(void)
{
    107a:	1141                	addi	sp,sp,-16
    107c:	e406                	sd	ra,8(sp)
    107e:	e022                	sd	s0,0(sp)
    1080:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
    1082:	00001097          	auipc	ra,0x1
    1086:	cc0080e7          	jalr	-832(ra) # 1d42 <fork>
  if(pid == -1)
    108a:	57fd                	li	a5,-1
    108c:	00f50663          	beq	a0,a5,1098 <fork1+0x1e>
    panic("fork");
  return pid;
}
    1090:	60a2                	ld	ra,8(sp)
    1092:	6402                	ld	s0,0(sp)
    1094:	0141                	addi	sp,sp,16
    1096:	8082                	ret
    panic("fork");
    1098:	00001517          	auipc	a0,0x1
    109c:	1f050513          	addi	a0,a0,496 # 2288 <malloc+0xf8>
    10a0:	00000097          	auipc	ra,0x0
    10a4:	fb4080e7          	jalr	-76(ra) # 1054 <panic>

00000000000010a8 <runcmd>:
{
    10a8:	7179                	addi	sp,sp,-48
    10aa:	f406                	sd	ra,40(sp)
    10ac:	f022                	sd	s0,32(sp)
    10ae:	ec26                	sd	s1,24(sp)
    10b0:	1800                	addi	s0,sp,48
  if(cmd == 0)
    10b2:	c10d                	beqz	a0,10d4 <runcmd+0x2c>
    10b4:	84aa                	mv	s1,a0
  switch(cmd->type){
    10b6:	4118                	lw	a4,0(a0)
    10b8:	4795                	li	a5,5
    10ba:	02e7e263          	bltu	a5,a4,10de <runcmd+0x36>
    10be:	00056783          	lwu	a5,0(a0)
    10c2:	078a                	slli	a5,a5,0x2
    10c4:	00001717          	auipc	a4,0x1
    10c8:	2c470713          	addi	a4,a4,708 # 2388 <malloc+0x1f8>
    10cc:	97ba                	add	a5,a5,a4
    10ce:	439c                	lw	a5,0(a5)
    10d0:	97ba                	add	a5,a5,a4
    10d2:	8782                	jr	a5
    exit(1);
    10d4:	4505                	li	a0,1
    10d6:	00001097          	auipc	ra,0x1
    10da:	c74080e7          	jalr	-908(ra) # 1d4a <exit>
    panic("runcmd");
    10de:	00001517          	auipc	a0,0x1
    10e2:	1b250513          	addi	a0,a0,434 # 2290 <malloc+0x100>
    10e6:	00000097          	auipc	ra,0x0
    10ea:	f6e080e7          	jalr	-146(ra) # 1054 <panic>
    if(ecmd->argv[0] == 0)
    10ee:	6508                	ld	a0,8(a0)
    10f0:	c515                	beqz	a0,111c <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
    10f2:	00848593          	addi	a1,s1,8
    10f6:	00001097          	auipc	ra,0x1
    10fa:	c8c080e7          	jalr	-884(ra) # 1d82 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
    10fe:	6490                	ld	a2,8(s1)
    1100:	00001597          	auipc	a1,0x1
    1104:	19858593          	addi	a1,a1,408 # 2298 <malloc+0x108>
    1108:	4509                	li	a0,2
    110a:	00001097          	auipc	ra,0x1
    110e:	f9a080e7          	jalr	-102(ra) # 20a4 <fprintf>
  exit(0);
    1112:	4501                	li	a0,0
    1114:	00001097          	auipc	ra,0x1
    1118:	c36080e7          	jalr	-970(ra) # 1d4a <exit>
      exit(1);
    111c:	4505                	li	a0,1
    111e:	00001097          	auipc	ra,0x1
    1122:	c2c080e7          	jalr	-980(ra) # 1d4a <exit>
    close(rcmd->fd);
    1126:	5148                	lw	a0,36(a0)
    1128:	00001097          	auipc	ra,0x1
    112c:	c4a080e7          	jalr	-950(ra) # 1d72 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
    1130:	508c                	lw	a1,32(s1)
    1132:	6888                	ld	a0,16(s1)
    1134:	00001097          	auipc	ra,0x1
    1138:	c56080e7          	jalr	-938(ra) # 1d8a <open>
    113c:	00054763          	bltz	a0,114a <runcmd+0xa2>
    runcmd(rcmd->cmd);
    1140:	6488                	ld	a0,8(s1)
    1142:	00000097          	auipc	ra,0x0
    1146:	f66080e7          	jalr	-154(ra) # 10a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
    114a:	6890                	ld	a2,16(s1)
    114c:	00001597          	auipc	a1,0x1
    1150:	15c58593          	addi	a1,a1,348 # 22a8 <malloc+0x118>
    1154:	4509                	li	a0,2
    1156:	00001097          	auipc	ra,0x1
    115a:	f4e080e7          	jalr	-178(ra) # 20a4 <fprintf>
      exit(1);
    115e:	4505                	li	a0,1
    1160:	00001097          	auipc	ra,0x1
    1164:	bea080e7          	jalr	-1046(ra) # 1d4a <exit>
    if(fork1() == 0)
    1168:	00000097          	auipc	ra,0x0
    116c:	f12080e7          	jalr	-238(ra) # 107a <fork1>
    1170:	c919                	beqz	a0,1186 <runcmd+0xde>
    wait(0);
    1172:	4501                	li	a0,0
    1174:	00001097          	auipc	ra,0x1
    1178:	bde080e7          	jalr	-1058(ra) # 1d52 <wait>
    runcmd(lcmd->right);
    117c:	6888                	ld	a0,16(s1)
    117e:	00000097          	auipc	ra,0x0
    1182:	f2a080e7          	jalr	-214(ra) # 10a8 <runcmd>
      runcmd(lcmd->left);
    1186:	6488                	ld	a0,8(s1)
    1188:	00000097          	auipc	ra,0x0
    118c:	f20080e7          	jalr	-224(ra) # 10a8 <runcmd>
    if(pipe(p) < 0)
    1190:	fd840513          	addi	a0,s0,-40
    1194:	00001097          	auipc	ra,0x1
    1198:	bc6080e7          	jalr	-1082(ra) # 1d5a <pipe>
    119c:	04054363          	bltz	a0,11e2 <runcmd+0x13a>
    if(fork1() == 0){
    11a0:	00000097          	auipc	ra,0x0
    11a4:	eda080e7          	jalr	-294(ra) # 107a <fork1>
    11a8:	c529                	beqz	a0,11f2 <runcmd+0x14a>
    if(fork1() == 0){
    11aa:	00000097          	auipc	ra,0x0
    11ae:	ed0080e7          	jalr	-304(ra) # 107a <fork1>
    11b2:	cd25                	beqz	a0,122a <runcmd+0x182>
    close(p[0]);
    11b4:	fd842503          	lw	a0,-40(s0)
    11b8:	00001097          	auipc	ra,0x1
    11bc:	bba080e7          	jalr	-1094(ra) # 1d72 <close>
    close(p[1]);
    11c0:	fdc42503          	lw	a0,-36(s0)
    11c4:	00001097          	auipc	ra,0x1
    11c8:	bae080e7          	jalr	-1106(ra) # 1d72 <close>
    wait(0);
    11cc:	4501                	li	a0,0
    11ce:	00001097          	auipc	ra,0x1
    11d2:	b84080e7          	jalr	-1148(ra) # 1d52 <wait>
    wait(0);
    11d6:	4501                	li	a0,0
    11d8:	00001097          	auipc	ra,0x1
    11dc:	b7a080e7          	jalr	-1158(ra) # 1d52 <wait>
    break;
    11e0:	bf0d                	j	1112 <runcmd+0x6a>
      panic("pipe");
    11e2:	00001517          	auipc	a0,0x1
    11e6:	0d650513          	addi	a0,a0,214 # 22b8 <malloc+0x128>
    11ea:	00000097          	auipc	ra,0x0
    11ee:	e6a080e7          	jalr	-406(ra) # 1054 <panic>
      close(1);
    11f2:	4505                	li	a0,1
    11f4:	00001097          	auipc	ra,0x1
    11f8:	b7e080e7          	jalr	-1154(ra) # 1d72 <close>
      dup(p[1]);
    11fc:	fdc42503          	lw	a0,-36(s0)
    1200:	00001097          	auipc	ra,0x1
    1204:	bc2080e7          	jalr	-1086(ra) # 1dc2 <dup>
      close(p[0]);
    1208:	fd842503          	lw	a0,-40(s0)
    120c:	00001097          	auipc	ra,0x1
    1210:	b66080e7          	jalr	-1178(ra) # 1d72 <close>
      close(p[1]);
    1214:	fdc42503          	lw	a0,-36(s0)
    1218:	00001097          	auipc	ra,0x1
    121c:	b5a080e7          	jalr	-1190(ra) # 1d72 <close>
      runcmd(pcmd->left);
    1220:	6488                	ld	a0,8(s1)
    1222:	00000097          	auipc	ra,0x0
    1226:	e86080e7          	jalr	-378(ra) # 10a8 <runcmd>
      close(0);
    122a:	00001097          	auipc	ra,0x1
    122e:	b48080e7          	jalr	-1208(ra) # 1d72 <close>
      dup(p[0]);
    1232:	fd842503          	lw	a0,-40(s0)
    1236:	00001097          	auipc	ra,0x1
    123a:	b8c080e7          	jalr	-1140(ra) # 1dc2 <dup>
      close(p[0]);
    123e:	fd842503          	lw	a0,-40(s0)
    1242:	00001097          	auipc	ra,0x1
    1246:	b30080e7          	jalr	-1232(ra) # 1d72 <close>
      close(p[1]);
    124a:	fdc42503          	lw	a0,-36(s0)
    124e:	00001097          	auipc	ra,0x1
    1252:	b24080e7          	jalr	-1244(ra) # 1d72 <close>
      runcmd(pcmd->right);
    1256:	6888                	ld	a0,16(s1)
    1258:	00000097          	auipc	ra,0x0
    125c:	e50080e7          	jalr	-432(ra) # 10a8 <runcmd>
    if(fork1() == 0)
    1260:	00000097          	auipc	ra,0x0
    1264:	e1a080e7          	jalr	-486(ra) # 107a <fork1>
    1268:	ea0515e3          	bnez	a0,1112 <runcmd+0x6a>
      runcmd(bcmd->cmd);
    126c:	6488                	ld	a0,8(s1)
    126e:	00000097          	auipc	ra,0x0
    1272:	e3a080e7          	jalr	-454(ra) # 10a8 <runcmd>

0000000000001276 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    1276:	1101                	addi	sp,sp,-32
    1278:	ec06                	sd	ra,24(sp)
    127a:	e822                	sd	s0,16(sp)
    127c:	e426                	sd	s1,8(sp)
    127e:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1280:	0a800513          	li	a0,168
    1284:	00001097          	auipc	ra,0x1
    1288:	f0c080e7          	jalr	-244(ra) # 2190 <malloc>
    128c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    128e:	0a800613          	li	a2,168
    1292:	4581                	li	a1,0
    1294:	00001097          	auipc	ra,0x1
    1298:	932080e7          	jalr	-1742(ra) # 1bc6 <memset>
  cmd->type = EXEC;
    129c:	4785                	li	a5,1
    129e:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
    12a0:	8526                	mv	a0,s1
    12a2:	60e2                	ld	ra,24(sp)
    12a4:	6442                	ld	s0,16(sp)
    12a6:	64a2                	ld	s1,8(sp)
    12a8:	6105                	addi	sp,sp,32
    12aa:	8082                	ret

00000000000012ac <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    12ac:	7139                	addi	sp,sp,-64
    12ae:	fc06                	sd	ra,56(sp)
    12b0:	f822                	sd	s0,48(sp)
    12b2:	f426                	sd	s1,40(sp)
    12b4:	f04a                	sd	s2,32(sp)
    12b6:	ec4e                	sd	s3,24(sp)
    12b8:	e852                	sd	s4,16(sp)
    12ba:	e456                	sd	s5,8(sp)
    12bc:	e05a                	sd	s6,0(sp)
    12be:	0080                	addi	s0,sp,64
    12c0:	8b2a                	mv	s6,a0
    12c2:	8aae                	mv	s5,a1
    12c4:	8a32                	mv	s4,a2
    12c6:	89b6                	mv	s3,a3
    12c8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    12ca:	02800513          	li	a0,40
    12ce:	00001097          	auipc	ra,0x1
    12d2:	ec2080e7          	jalr	-318(ra) # 2190 <malloc>
    12d6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    12d8:	02800613          	li	a2,40
    12dc:	4581                	li	a1,0
    12de:	00001097          	auipc	ra,0x1
    12e2:	8e8080e7          	jalr	-1816(ra) # 1bc6 <memset>
  cmd->type = REDIR;
    12e6:	4789                	li	a5,2
    12e8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
    12ea:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
    12ee:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
    12f2:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
    12f6:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
    12fa:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
    12fe:	8526                	mv	a0,s1
    1300:	70e2                	ld	ra,56(sp)
    1302:	7442                	ld	s0,48(sp)
    1304:	74a2                	ld	s1,40(sp)
    1306:	7902                	ld	s2,32(sp)
    1308:	69e2                	ld	s3,24(sp)
    130a:	6a42                	ld	s4,16(sp)
    130c:	6aa2                	ld	s5,8(sp)
    130e:	6b02                	ld	s6,0(sp)
    1310:	6121                	addi	sp,sp,64
    1312:	8082                	ret

0000000000001314 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	e84a                	sd	s2,16(sp)
    131e:	e44e                	sd	s3,8(sp)
    1320:	1800                	addi	s0,sp,48
    1322:	89aa                	mv	s3,a0
    1324:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1326:	4561                	li	a0,24
    1328:	00001097          	auipc	ra,0x1
    132c:	e68080e7          	jalr	-408(ra) # 2190 <malloc>
    1330:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    1332:	4661                	li	a2,24
    1334:	4581                	li	a1,0
    1336:	00001097          	auipc	ra,0x1
    133a:	890080e7          	jalr	-1904(ra) # 1bc6 <memset>
  cmd->type = PIPE;
    133e:	478d                	li	a5,3
    1340:	c09c                	sw	a5,0(s1)
  cmd->left = left;
    1342:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
    1346:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
    134a:	8526                	mv	a0,s1
    134c:	70a2                	ld	ra,40(sp)
    134e:	7402                	ld	s0,32(sp)
    1350:	64e2                	ld	s1,24(sp)
    1352:	6942                	ld	s2,16(sp)
    1354:	69a2                	ld	s3,8(sp)
    1356:	6145                	addi	sp,sp,48
    1358:	8082                	ret

000000000000135a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    135a:	7179                	addi	sp,sp,-48
    135c:	f406                	sd	ra,40(sp)
    135e:	f022                	sd	s0,32(sp)
    1360:	ec26                	sd	s1,24(sp)
    1362:	e84a                	sd	s2,16(sp)
    1364:	e44e                	sd	s3,8(sp)
    1366:	1800                	addi	s0,sp,48
    1368:	89aa                	mv	s3,a0
    136a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    136c:	4561                	li	a0,24
    136e:	00001097          	auipc	ra,0x1
    1372:	e22080e7          	jalr	-478(ra) # 2190 <malloc>
    1376:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    1378:	4661                	li	a2,24
    137a:	4581                	li	a1,0
    137c:	00001097          	auipc	ra,0x1
    1380:	84a080e7          	jalr	-1974(ra) # 1bc6 <memset>
  cmd->type = LIST;
    1384:	4791                	li	a5,4
    1386:	c09c                	sw	a5,0(s1)
  cmd->left = left;
    1388:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
    138c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
    1390:	8526                	mv	a0,s1
    1392:	70a2                	ld	ra,40(sp)
    1394:	7402                	ld	s0,32(sp)
    1396:	64e2                	ld	s1,24(sp)
    1398:	6942                	ld	s2,16(sp)
    139a:	69a2                	ld	s3,8(sp)
    139c:	6145                	addi	sp,sp,48
    139e:	8082                	ret

00000000000013a0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    13a0:	1101                	addi	sp,sp,-32
    13a2:	ec06                	sd	ra,24(sp)
    13a4:	e822                	sd	s0,16(sp)
    13a6:	e426                	sd	s1,8(sp)
    13a8:	e04a                	sd	s2,0(sp)
    13aa:	1000                	addi	s0,sp,32
    13ac:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13ae:	4541                	li	a0,16
    13b0:	00001097          	auipc	ra,0x1
    13b4:	de0080e7          	jalr	-544(ra) # 2190 <malloc>
    13b8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    13ba:	4641                	li	a2,16
    13bc:	4581                	li	a1,0
    13be:	00001097          	auipc	ra,0x1
    13c2:	808080e7          	jalr	-2040(ra) # 1bc6 <memset>
  cmd->type = BACK;
    13c6:	4795                	li	a5,5
    13c8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
    13ca:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
    13ce:	8526                	mv	a0,s1
    13d0:	60e2                	ld	ra,24(sp)
    13d2:	6442                	ld	s0,16(sp)
    13d4:	64a2                	ld	s1,8(sp)
    13d6:	6902                	ld	s2,0(sp)
    13d8:	6105                	addi	sp,sp,32
    13da:	8082                	ret

00000000000013dc <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    13dc:	7139                	addi	sp,sp,-64
    13de:	fc06                	sd	ra,56(sp)
    13e0:	f822                	sd	s0,48(sp)
    13e2:	f426                	sd	s1,40(sp)
    13e4:	f04a                	sd	s2,32(sp)
    13e6:	ec4e                	sd	s3,24(sp)
    13e8:	e852                	sd	s4,16(sp)
    13ea:	e456                	sd	s5,8(sp)
    13ec:	e05a                	sd	s6,0(sp)
    13ee:	0080                	addi	s0,sp,64
    13f0:	8a2a                	mv	s4,a0
    13f2:	892e                	mv	s2,a1
    13f4:	8ab2                	mv	s5,a2
    13f6:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
    13f8:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
    13fa:	00001997          	auipc	s3,0x1
    13fe:	fe698993          	addi	s3,s3,-26 # 23e0 <whitespace>
    1402:	00b4fd63          	bgeu	s1,a1,141c <gettoken+0x40>
    1406:	0004c583          	lbu	a1,0(s1)
    140a:	854e                	mv	a0,s3
    140c:	00000097          	auipc	ra,0x0
    1410:	7e0080e7          	jalr	2016(ra) # 1bec <strchr>
    1414:	c501                	beqz	a0,141c <gettoken+0x40>
    s++;
    1416:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
    1418:	fe9917e3          	bne	s2,s1,1406 <gettoken+0x2a>
  if(q)
    141c:	000a8463          	beqz	s5,1424 <gettoken+0x48>
    *q = s;
    1420:	009ab023          	sd	s1,0(s5)
  ret = *s;
    1424:	0004c783          	lbu	a5,0(s1)
    1428:	00078a9b          	sext.w	s5,a5
  switch(*s){
    142c:	03c00713          	li	a4,60
    1430:	06f76563          	bltu	a4,a5,149a <gettoken+0xbe>
    1434:	03a00713          	li	a4,58
    1438:	00f76e63          	bltu	a4,a5,1454 <gettoken+0x78>
    143c:	cf89                	beqz	a5,1456 <gettoken+0x7a>
    143e:	02600713          	li	a4,38
    1442:	00e78963          	beq	a5,a4,1454 <gettoken+0x78>
    1446:	fd87879b          	addiw	a5,a5,-40
    144a:	0ff7f793          	andi	a5,a5,255
    144e:	4705                	li	a4,1
    1450:	06f76c63          	bltu	a4,a5,14c8 <gettoken+0xec>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    1454:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    1456:	000b0463          	beqz	s6,145e <gettoken+0x82>
    *eq = s;
    145a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
    145e:	00001997          	auipc	s3,0x1
    1462:	f8298993          	addi	s3,s3,-126 # 23e0 <whitespace>
    1466:	0124fd63          	bgeu	s1,s2,1480 <gettoken+0xa4>
    146a:	0004c583          	lbu	a1,0(s1)
    146e:	854e                	mv	a0,s3
    1470:	00000097          	auipc	ra,0x0
    1474:	77c080e7          	jalr	1916(ra) # 1bec <strchr>
    1478:	c501                	beqz	a0,1480 <gettoken+0xa4>
    s++;
    147a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
    147c:	fe9917e3          	bne	s2,s1,146a <gettoken+0x8e>
  *ps = s;
    1480:	009a3023          	sd	s1,0(s4)
  return ret;
}
    1484:	8556                	mv	a0,s5
    1486:	70e2                	ld	ra,56(sp)
    1488:	7442                	ld	s0,48(sp)
    148a:	74a2                	ld	s1,40(sp)
    148c:	7902                	ld	s2,32(sp)
    148e:	69e2                	ld	s3,24(sp)
    1490:	6a42                	ld	s4,16(sp)
    1492:	6aa2                	ld	s5,8(sp)
    1494:	6b02                	ld	s6,0(sp)
    1496:	6121                	addi	sp,sp,64
    1498:	8082                	ret
  switch(*s){
    149a:	03e00713          	li	a4,62
    149e:	02e79163          	bne	a5,a4,14c0 <gettoken+0xe4>
    s++;
    14a2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
    14a6:	0014c703          	lbu	a4,1(s1)
    14aa:	03e00793          	li	a5,62
      s++;
    14ae:	0489                	addi	s1,s1,2
      ret = '+';
    14b0:	02b00a93          	li	s5,43
    if(*s == '>'){
    14b4:	faf701e3          	beq	a4,a5,1456 <gettoken+0x7a>
    s++;
    14b8:	84b6                	mv	s1,a3
  ret = *s;
    14ba:	03e00a93          	li	s5,62
    14be:	bf61                	j	1456 <gettoken+0x7a>
  switch(*s){
    14c0:	07c00713          	li	a4,124
    14c4:	f8e788e3          	beq	a5,a4,1454 <gettoken+0x78>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    14c8:	00001997          	auipc	s3,0x1
    14cc:	f1898993          	addi	s3,s3,-232 # 23e0 <whitespace>
    14d0:	00001a97          	auipc	s5,0x1
    14d4:	f08a8a93          	addi	s5,s5,-248 # 23d8 <symbols>
    14d8:	0324f563          	bgeu	s1,s2,1502 <gettoken+0x126>
    14dc:	0004c583          	lbu	a1,0(s1)
    14e0:	854e                	mv	a0,s3
    14e2:	00000097          	auipc	ra,0x0
    14e6:	70a080e7          	jalr	1802(ra) # 1bec <strchr>
    14ea:	e505                	bnez	a0,1512 <gettoken+0x136>
    14ec:	0004c583          	lbu	a1,0(s1)
    14f0:	8556                	mv	a0,s5
    14f2:	00000097          	auipc	ra,0x0
    14f6:	6fa080e7          	jalr	1786(ra) # 1bec <strchr>
    14fa:	e909                	bnez	a0,150c <gettoken+0x130>
      s++;
    14fc:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    14fe:	fc991fe3          	bne	s2,s1,14dc <gettoken+0x100>
  if(eq)
    1502:	06100a93          	li	s5,97
    1506:	f40b1ae3          	bnez	s6,145a <gettoken+0x7e>
    150a:	bf9d                	j	1480 <gettoken+0xa4>
    ret = 'a';
    150c:	06100a93          	li	s5,97
    1510:	b799                	j	1456 <gettoken+0x7a>
    1512:	06100a93          	li	s5,97
    1516:	b781                	j	1456 <gettoken+0x7a>

0000000000001518 <peek>:

int
peek(char **ps, char *es, char *toks)
{
    1518:	7139                	addi	sp,sp,-64
    151a:	fc06                	sd	ra,56(sp)
    151c:	f822                	sd	s0,48(sp)
    151e:	f426                	sd	s1,40(sp)
    1520:	f04a                	sd	s2,32(sp)
    1522:	ec4e                	sd	s3,24(sp)
    1524:	e852                	sd	s4,16(sp)
    1526:	e456                	sd	s5,8(sp)
    1528:	0080                	addi	s0,sp,64
    152a:	8a2a                	mv	s4,a0
    152c:	892e                	mv	s2,a1
    152e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
    1530:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
    1532:	00001997          	auipc	s3,0x1
    1536:	eae98993          	addi	s3,s3,-338 # 23e0 <whitespace>
    153a:	00b4fd63          	bgeu	s1,a1,1554 <peek+0x3c>
    153e:	0004c583          	lbu	a1,0(s1)
    1542:	854e                	mv	a0,s3
    1544:	00000097          	auipc	ra,0x0
    1548:	6a8080e7          	jalr	1704(ra) # 1bec <strchr>
    154c:	c501                	beqz	a0,1554 <peek+0x3c>
    s++;
    154e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
    1550:	fe9917e3          	bne	s2,s1,153e <peek+0x26>
  *ps = s;
    1554:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
    1558:	0004c583          	lbu	a1,0(s1)
    155c:	4501                	li	a0,0
    155e:	e991                	bnez	a1,1572 <peek+0x5a>
}
    1560:	70e2                	ld	ra,56(sp)
    1562:	7442                	ld	s0,48(sp)
    1564:	74a2                	ld	s1,40(sp)
    1566:	7902                	ld	s2,32(sp)
    1568:	69e2                	ld	s3,24(sp)
    156a:	6a42                	ld	s4,16(sp)
    156c:	6aa2                	ld	s5,8(sp)
    156e:	6121                	addi	sp,sp,64
    1570:	8082                	ret
  return *s && strchr(toks, *s);
    1572:	8556                	mv	a0,s5
    1574:	00000097          	auipc	ra,0x0
    1578:	678080e7          	jalr	1656(ra) # 1bec <strchr>
    157c:	00a03533          	snez	a0,a0
    1580:	b7c5                	j	1560 <peek+0x48>

0000000000001582 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    1582:	7159                	addi	sp,sp,-112
    1584:	f486                	sd	ra,104(sp)
    1586:	f0a2                	sd	s0,96(sp)
    1588:	eca6                	sd	s1,88(sp)
    158a:	e8ca                	sd	s2,80(sp)
    158c:	e4ce                	sd	s3,72(sp)
    158e:	e0d2                	sd	s4,64(sp)
    1590:	fc56                	sd	s5,56(sp)
    1592:	f85a                	sd	s6,48(sp)
    1594:	f45e                	sd	s7,40(sp)
    1596:	f062                	sd	s8,32(sp)
    1598:	ec66                	sd	s9,24(sp)
    159a:	1880                	addi	s0,sp,112
    159c:	8a2a                	mv	s4,a0
    159e:	89ae                	mv	s3,a1
    15a0:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    15a2:	00001b97          	auipc	s7,0x1
    15a6:	d3eb8b93          	addi	s7,s7,-706 # 22e0 <malloc+0x150>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
    15aa:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
    15ae:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
    15b2:	a02d                	j	15dc <parseredirs+0x5a>
      panic("missing file for redirection");
    15b4:	00001517          	auipc	a0,0x1
    15b8:	d0c50513          	addi	a0,a0,-756 # 22c0 <malloc+0x130>
    15bc:	00000097          	auipc	ra,0x0
    15c0:	a98080e7          	jalr	-1384(ra) # 1054 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    15c4:	4701                	li	a4,0
    15c6:	4681                	li	a3,0
    15c8:	f9043603          	ld	a2,-112(s0)
    15cc:	f9843583          	ld	a1,-104(s0)
    15d0:	8552                	mv	a0,s4
    15d2:	00000097          	auipc	ra,0x0
    15d6:	cda080e7          	jalr	-806(ra) # 12ac <redircmd>
    15da:	8a2a                	mv	s4,a0
    switch(tok){
    15dc:	03e00b13          	li	s6,62
    15e0:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
    15e4:	865e                	mv	a2,s7
    15e6:	85ca                	mv	a1,s2
    15e8:	854e                	mv	a0,s3
    15ea:	00000097          	auipc	ra,0x0
    15ee:	f2e080e7          	jalr	-210(ra) # 1518 <peek>
    15f2:	c925                	beqz	a0,1662 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
    15f4:	4681                	li	a3,0
    15f6:	4601                	li	a2,0
    15f8:	85ca                	mv	a1,s2
    15fa:	854e                	mv	a0,s3
    15fc:	00000097          	auipc	ra,0x0
    1600:	de0080e7          	jalr	-544(ra) # 13dc <gettoken>
    1604:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
    1606:	f9040693          	addi	a3,s0,-112
    160a:	f9840613          	addi	a2,s0,-104
    160e:	85ca                	mv	a1,s2
    1610:	854e                	mv	a0,s3
    1612:	00000097          	auipc	ra,0x0
    1616:	dca080e7          	jalr	-566(ra) # 13dc <gettoken>
    161a:	f9851de3          	bne	a0,s8,15b4 <parseredirs+0x32>
    switch(tok){
    161e:	fb9483e3          	beq	s1,s9,15c4 <parseredirs+0x42>
    1622:	03648263          	beq	s1,s6,1646 <parseredirs+0xc4>
    1626:	fb549fe3          	bne	s1,s5,15e4 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    162a:	4705                	li	a4,1
    162c:	20100693          	li	a3,513
    1630:	f9043603          	ld	a2,-112(s0)
    1634:	f9843583          	ld	a1,-104(s0)
    1638:	8552                	mv	a0,s4
    163a:	00000097          	auipc	ra,0x0
    163e:	c72080e7          	jalr	-910(ra) # 12ac <redircmd>
    1642:	8a2a                	mv	s4,a0
      break;
    1644:	bf61                	j	15dc <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1646:	4705                	li	a4,1
    1648:	20100693          	li	a3,513
    164c:	f9043603          	ld	a2,-112(s0)
    1650:	f9843583          	ld	a1,-104(s0)
    1654:	8552                	mv	a0,s4
    1656:	00000097          	auipc	ra,0x0
    165a:	c56080e7          	jalr	-938(ra) # 12ac <redircmd>
    165e:	8a2a                	mv	s4,a0
      break;
    1660:	bfb5                	j	15dc <parseredirs+0x5a>
    }
  }
  return cmd;
}
    1662:	8552                	mv	a0,s4
    1664:	70a6                	ld	ra,104(sp)
    1666:	7406                	ld	s0,96(sp)
    1668:	64e6                	ld	s1,88(sp)
    166a:	6946                	ld	s2,80(sp)
    166c:	69a6                	ld	s3,72(sp)
    166e:	6a06                	ld	s4,64(sp)
    1670:	7ae2                	ld	s5,56(sp)
    1672:	7b42                	ld	s6,48(sp)
    1674:	7ba2                	ld	s7,40(sp)
    1676:	7c02                	ld	s8,32(sp)
    1678:	6ce2                	ld	s9,24(sp)
    167a:	6165                	addi	sp,sp,112
    167c:	8082                	ret

000000000000167e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
    167e:	7159                	addi	sp,sp,-112
    1680:	f486                	sd	ra,104(sp)
    1682:	f0a2                	sd	s0,96(sp)
    1684:	eca6                	sd	s1,88(sp)
    1686:	e8ca                	sd	s2,80(sp)
    1688:	e4ce                	sd	s3,72(sp)
    168a:	e0d2                	sd	s4,64(sp)
    168c:	fc56                	sd	s5,56(sp)
    168e:	f85a                	sd	s6,48(sp)
    1690:	f45e                	sd	s7,40(sp)
    1692:	f062                	sd	s8,32(sp)
    1694:	ec66                	sd	s9,24(sp)
    1696:	1880                	addi	s0,sp,112
    1698:	8a2a                	mv	s4,a0
    169a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    169c:	00001617          	auipc	a2,0x1
    16a0:	c4c60613          	addi	a2,a2,-948 # 22e8 <malloc+0x158>
    16a4:	00000097          	auipc	ra,0x0
    16a8:	e74080e7          	jalr	-396(ra) # 1518 <peek>
    16ac:	e905                	bnez	a0,16dc <parseexec+0x5e>
    16ae:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
    16b0:	00000097          	auipc	ra,0x0
    16b4:	bc6080e7          	jalr	-1082(ra) # 1276 <execcmd>
    16b8:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
    16ba:	8656                	mv	a2,s5
    16bc:	85d2                	mv	a1,s4
    16be:	00000097          	auipc	ra,0x0
    16c2:	ec4080e7          	jalr	-316(ra) # 1582 <parseredirs>
    16c6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
    16c8:	008c0913          	addi	s2,s8,8
    16cc:	00001b17          	auipc	s6,0x1
    16d0:	c3cb0b13          	addi	s6,s6,-964 # 2308 <malloc+0x178>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
    16d4:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
    16d8:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
    16da:	a0b1                	j	1726 <parseexec+0xa8>
    return parseblock(ps, es);
    16dc:	85d6                	mv	a1,s5
    16de:	8552                	mv	a0,s4
    16e0:	00000097          	auipc	ra,0x0
    16e4:	1bc080e7          	jalr	444(ra) # 189c <parseblock>
    16e8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
    16ea:	8526                	mv	a0,s1
    16ec:	70a6                	ld	ra,104(sp)
    16ee:	7406                	ld	s0,96(sp)
    16f0:	64e6                	ld	s1,88(sp)
    16f2:	6946                	ld	s2,80(sp)
    16f4:	69a6                	ld	s3,72(sp)
    16f6:	6a06                	ld	s4,64(sp)
    16f8:	7ae2                	ld	s5,56(sp)
    16fa:	7b42                	ld	s6,48(sp)
    16fc:	7ba2                	ld	s7,40(sp)
    16fe:	7c02                	ld	s8,32(sp)
    1700:	6ce2                	ld	s9,24(sp)
    1702:	6165                	addi	sp,sp,112
    1704:	8082                	ret
      panic("syntax");
    1706:	00001517          	auipc	a0,0x1
    170a:	bea50513          	addi	a0,a0,-1046 # 22f0 <malloc+0x160>
    170e:	00000097          	auipc	ra,0x0
    1712:	946080e7          	jalr	-1722(ra) # 1054 <panic>
    ret = parseredirs(ret, ps, es);
    1716:	8656                	mv	a2,s5
    1718:	85d2                	mv	a1,s4
    171a:	8526                	mv	a0,s1
    171c:	00000097          	auipc	ra,0x0
    1720:	e66080e7          	jalr	-410(ra) # 1582 <parseredirs>
    1724:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
    1726:	865a                	mv	a2,s6
    1728:	85d6                	mv	a1,s5
    172a:	8552                	mv	a0,s4
    172c:	00000097          	auipc	ra,0x0
    1730:	dec080e7          	jalr	-532(ra) # 1518 <peek>
    1734:	e131                	bnez	a0,1778 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    1736:	f9040693          	addi	a3,s0,-112
    173a:	f9840613          	addi	a2,s0,-104
    173e:	85d6                	mv	a1,s5
    1740:	8552                	mv	a0,s4
    1742:	00000097          	auipc	ra,0x0
    1746:	c9a080e7          	jalr	-870(ra) # 13dc <gettoken>
    174a:	c51d                	beqz	a0,1778 <parseexec+0xfa>
    if(tok != 'a')
    174c:	fb951de3          	bne	a0,s9,1706 <parseexec+0x88>
    cmd->argv[argc] = q;
    1750:	f9843783          	ld	a5,-104(s0)
    1754:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
    1758:	f9043783          	ld	a5,-112(s0)
    175c:	04f93823          	sd	a5,80(s2)
    argc++;
    1760:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
    1762:	0921                	addi	s2,s2,8
    1764:	fb7999e3          	bne	s3,s7,1716 <parseexec+0x98>
      panic("too many args");
    1768:	00001517          	auipc	a0,0x1
    176c:	b9050513          	addi	a0,a0,-1136 # 22f8 <malloc+0x168>
    1770:	00000097          	auipc	ra,0x0
    1774:	8e4080e7          	jalr	-1820(ra) # 1054 <panic>
  cmd->argv[argc] = 0;
    1778:	098e                	slli	s3,s3,0x3
    177a:	99e2                	add	s3,s3,s8
    177c:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
    1780:	0409bc23          	sd	zero,88(s3)
  return ret;
    1784:	b79d                	j	16ea <parseexec+0x6c>

0000000000001786 <parsepipe>:
{
    1786:	7179                	addi	sp,sp,-48
    1788:	f406                	sd	ra,40(sp)
    178a:	f022                	sd	s0,32(sp)
    178c:	ec26                	sd	s1,24(sp)
    178e:	e84a                	sd	s2,16(sp)
    1790:	e44e                	sd	s3,8(sp)
    1792:	1800                	addi	s0,sp,48
    1794:	892a                	mv	s2,a0
    1796:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
    1798:	00000097          	auipc	ra,0x0
    179c:	ee6080e7          	jalr	-282(ra) # 167e <parseexec>
    17a0:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
    17a2:	00001617          	auipc	a2,0x1
    17a6:	b6e60613          	addi	a2,a2,-1170 # 2310 <malloc+0x180>
    17aa:	85ce                	mv	a1,s3
    17ac:	854a                	mv	a0,s2
    17ae:	00000097          	auipc	ra,0x0
    17b2:	d6a080e7          	jalr	-662(ra) # 1518 <peek>
    17b6:	e909                	bnez	a0,17c8 <parsepipe+0x42>
}
    17b8:	8526                	mv	a0,s1
    17ba:	70a2                	ld	ra,40(sp)
    17bc:	7402                	ld	s0,32(sp)
    17be:	64e2                	ld	s1,24(sp)
    17c0:	6942                	ld	s2,16(sp)
    17c2:	69a2                	ld	s3,8(sp)
    17c4:	6145                	addi	sp,sp,48
    17c6:	8082                	ret
    gettoken(ps, es, 0, 0);
    17c8:	4681                	li	a3,0
    17ca:	4601                	li	a2,0
    17cc:	85ce                	mv	a1,s3
    17ce:	854a                	mv	a0,s2
    17d0:	00000097          	auipc	ra,0x0
    17d4:	c0c080e7          	jalr	-1012(ra) # 13dc <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
    17d8:	85ce                	mv	a1,s3
    17da:	854a                	mv	a0,s2
    17dc:	00000097          	auipc	ra,0x0
    17e0:	faa080e7          	jalr	-86(ra) # 1786 <parsepipe>
    17e4:	85aa                	mv	a1,a0
    17e6:	8526                	mv	a0,s1
    17e8:	00000097          	auipc	ra,0x0
    17ec:	b2c080e7          	jalr	-1236(ra) # 1314 <pipecmd>
    17f0:	84aa                	mv	s1,a0
  return cmd;
    17f2:	b7d9                	j	17b8 <parsepipe+0x32>

00000000000017f4 <parseline>:
{
    17f4:	7179                	addi	sp,sp,-48
    17f6:	f406                	sd	ra,40(sp)
    17f8:	f022                	sd	s0,32(sp)
    17fa:	ec26                	sd	s1,24(sp)
    17fc:	e84a                	sd	s2,16(sp)
    17fe:	e44e                	sd	s3,8(sp)
    1800:	e052                	sd	s4,0(sp)
    1802:	1800                	addi	s0,sp,48
    1804:	892a                	mv	s2,a0
    1806:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
    1808:	00000097          	auipc	ra,0x0
    180c:	f7e080e7          	jalr	-130(ra) # 1786 <parsepipe>
    1810:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
    1812:	00001a17          	auipc	s4,0x1
    1816:	b06a0a13          	addi	s4,s4,-1274 # 2318 <malloc+0x188>
    181a:	8652                	mv	a2,s4
    181c:	85ce                	mv	a1,s3
    181e:	854a                	mv	a0,s2
    1820:	00000097          	auipc	ra,0x0
    1824:	cf8080e7          	jalr	-776(ra) # 1518 <peek>
    1828:	c105                	beqz	a0,1848 <parseline+0x54>
    gettoken(ps, es, 0, 0);
    182a:	4681                	li	a3,0
    182c:	4601                	li	a2,0
    182e:	85ce                	mv	a1,s3
    1830:	854a                	mv	a0,s2
    1832:	00000097          	auipc	ra,0x0
    1836:	baa080e7          	jalr	-1110(ra) # 13dc <gettoken>
    cmd = backcmd(cmd);
    183a:	8526                	mv	a0,s1
    183c:	00000097          	auipc	ra,0x0
    1840:	b64080e7          	jalr	-1180(ra) # 13a0 <backcmd>
    1844:	84aa                	mv	s1,a0
    1846:	bfd1                	j	181a <parseline+0x26>
  if(peek(ps, es, ";")){
    1848:	00001617          	auipc	a2,0x1
    184c:	ad860613          	addi	a2,a2,-1320 # 2320 <malloc+0x190>
    1850:	85ce                	mv	a1,s3
    1852:	854a                	mv	a0,s2
    1854:	00000097          	auipc	ra,0x0
    1858:	cc4080e7          	jalr	-828(ra) # 1518 <peek>
    185c:	e911                	bnez	a0,1870 <parseline+0x7c>
}
    185e:	8526                	mv	a0,s1
    1860:	70a2                	ld	ra,40(sp)
    1862:	7402                	ld	s0,32(sp)
    1864:	64e2                	ld	s1,24(sp)
    1866:	6942                	ld	s2,16(sp)
    1868:	69a2                	ld	s3,8(sp)
    186a:	6a02                	ld	s4,0(sp)
    186c:	6145                	addi	sp,sp,48
    186e:	8082                	ret
    gettoken(ps, es, 0, 0);
    1870:	4681                	li	a3,0
    1872:	4601                	li	a2,0
    1874:	85ce                	mv	a1,s3
    1876:	854a                	mv	a0,s2
    1878:	00000097          	auipc	ra,0x0
    187c:	b64080e7          	jalr	-1180(ra) # 13dc <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
    1880:	85ce                	mv	a1,s3
    1882:	854a                	mv	a0,s2
    1884:	00000097          	auipc	ra,0x0
    1888:	f70080e7          	jalr	-144(ra) # 17f4 <parseline>
    188c:	85aa                	mv	a1,a0
    188e:	8526                	mv	a0,s1
    1890:	00000097          	auipc	ra,0x0
    1894:	aca080e7          	jalr	-1334(ra) # 135a <listcmd>
    1898:	84aa                	mv	s1,a0
  return cmd;
    189a:	b7d1                	j	185e <parseline+0x6a>

000000000000189c <parseblock>:
{
    189c:	7179                	addi	sp,sp,-48
    189e:	f406                	sd	ra,40(sp)
    18a0:	f022                	sd	s0,32(sp)
    18a2:	ec26                	sd	s1,24(sp)
    18a4:	e84a                	sd	s2,16(sp)
    18a6:	e44e                	sd	s3,8(sp)
    18a8:	1800                	addi	s0,sp,48
    18aa:	84aa                	mv	s1,a0
    18ac:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
    18ae:	00001617          	auipc	a2,0x1
    18b2:	a3a60613          	addi	a2,a2,-1478 # 22e8 <malloc+0x158>
    18b6:	00000097          	auipc	ra,0x0
    18ba:	c62080e7          	jalr	-926(ra) # 1518 <peek>
    18be:	c12d                	beqz	a0,1920 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
    18c0:	4681                	li	a3,0
    18c2:	4601                	li	a2,0
    18c4:	85ca                	mv	a1,s2
    18c6:	8526                	mv	a0,s1
    18c8:	00000097          	auipc	ra,0x0
    18cc:	b14080e7          	jalr	-1260(ra) # 13dc <gettoken>
  cmd = parseline(ps, es);
    18d0:	85ca                	mv	a1,s2
    18d2:	8526                	mv	a0,s1
    18d4:	00000097          	auipc	ra,0x0
    18d8:	f20080e7          	jalr	-224(ra) # 17f4 <parseline>
    18dc:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
    18de:	00001617          	auipc	a2,0x1
    18e2:	a5a60613          	addi	a2,a2,-1446 # 2338 <malloc+0x1a8>
    18e6:	85ca                	mv	a1,s2
    18e8:	8526                	mv	a0,s1
    18ea:	00000097          	auipc	ra,0x0
    18ee:	c2e080e7          	jalr	-978(ra) # 1518 <peek>
    18f2:	cd1d                	beqz	a0,1930 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
    18f4:	4681                	li	a3,0
    18f6:	4601                	li	a2,0
    18f8:	85ca                	mv	a1,s2
    18fa:	8526                	mv	a0,s1
    18fc:	00000097          	auipc	ra,0x0
    1900:	ae0080e7          	jalr	-1312(ra) # 13dc <gettoken>
  cmd = parseredirs(cmd, ps, es);
    1904:	864a                	mv	a2,s2
    1906:	85a6                	mv	a1,s1
    1908:	854e                	mv	a0,s3
    190a:	00000097          	auipc	ra,0x0
    190e:	c78080e7          	jalr	-904(ra) # 1582 <parseredirs>
}
    1912:	70a2                	ld	ra,40(sp)
    1914:	7402                	ld	s0,32(sp)
    1916:	64e2                	ld	s1,24(sp)
    1918:	6942                	ld	s2,16(sp)
    191a:	69a2                	ld	s3,8(sp)
    191c:	6145                	addi	sp,sp,48
    191e:	8082                	ret
    panic("parseblock");
    1920:	00001517          	auipc	a0,0x1
    1924:	a0850513          	addi	a0,a0,-1528 # 2328 <malloc+0x198>
    1928:	fffff097          	auipc	ra,0xfffff
    192c:	72c080e7          	jalr	1836(ra) # 1054 <panic>
    panic("syntax - missing )");
    1930:	00001517          	auipc	a0,0x1
    1934:	a1050513          	addi	a0,a0,-1520 # 2340 <malloc+0x1b0>
    1938:	fffff097          	auipc	ra,0xfffff
    193c:	71c080e7          	jalr	1820(ra) # 1054 <panic>

0000000000001940 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    1940:	1101                	addi	sp,sp,-32
    1942:	ec06                	sd	ra,24(sp)
    1944:	e822                	sd	s0,16(sp)
    1946:	e426                	sd	s1,8(sp)
    1948:	1000                	addi	s0,sp,32
    194a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    194c:	c521                	beqz	a0,1994 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
    194e:	4118                	lw	a4,0(a0)
    1950:	4795                	li	a5,5
    1952:	04e7e163          	bltu	a5,a4,1994 <nulterminate+0x54>
    1956:	00056783          	lwu	a5,0(a0)
    195a:	078a                	slli	a5,a5,0x2
    195c:	00001717          	auipc	a4,0x1
    1960:	a4470713          	addi	a4,a4,-1468 # 23a0 <malloc+0x210>
    1964:	97ba                	add	a5,a5,a4
    1966:	439c                	lw	a5,0(a5)
    1968:	97ba                	add	a5,a5,a4
    196a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    196c:	651c                	ld	a5,8(a0)
    196e:	c39d                	beqz	a5,1994 <nulterminate+0x54>
    1970:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
    1974:	67b8                	ld	a4,72(a5)
    1976:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
    197a:	07a1                	addi	a5,a5,8
    197c:	ff87b703          	ld	a4,-8(a5)
    1980:	fb75                	bnez	a4,1974 <nulterminate+0x34>
    1982:	a809                	j	1994 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    1984:	6508                	ld	a0,8(a0)
    1986:	00000097          	auipc	ra,0x0
    198a:	fba080e7          	jalr	-70(ra) # 1940 <nulterminate>
    *rcmd->efile = 0;
    198e:	6c9c                	ld	a5,24(s1)
    1990:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1994:	8526                	mv	a0,s1
    1996:	60e2                	ld	ra,24(sp)
    1998:	6442                	ld	s0,16(sp)
    199a:	64a2                	ld	s1,8(sp)
    199c:	6105                	addi	sp,sp,32
    199e:	8082                	ret
    nulterminate(pcmd->left);
    19a0:	6508                	ld	a0,8(a0)
    19a2:	00000097          	auipc	ra,0x0
    19a6:	f9e080e7          	jalr	-98(ra) # 1940 <nulterminate>
    nulterminate(pcmd->right);
    19aa:	6888                	ld	a0,16(s1)
    19ac:	00000097          	auipc	ra,0x0
    19b0:	f94080e7          	jalr	-108(ra) # 1940 <nulterminate>
    break;
    19b4:	b7c5                	j	1994 <nulterminate+0x54>
    nulterminate(lcmd->left);
    19b6:	6508                	ld	a0,8(a0)
    19b8:	00000097          	auipc	ra,0x0
    19bc:	f88080e7          	jalr	-120(ra) # 1940 <nulterminate>
    nulterminate(lcmd->right);
    19c0:	6888                	ld	a0,16(s1)
    19c2:	00000097          	auipc	ra,0x0
    19c6:	f7e080e7          	jalr	-130(ra) # 1940 <nulterminate>
    break;
    19ca:	b7e9                	j	1994 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
    19cc:	6508                	ld	a0,8(a0)
    19ce:	00000097          	auipc	ra,0x0
    19d2:	f72080e7          	jalr	-142(ra) # 1940 <nulterminate>
    break;
    19d6:	bf7d                	j	1994 <nulterminate+0x54>

00000000000019d8 <parsecmd>:
{
    19d8:	7179                	addi	sp,sp,-48
    19da:	f406                	sd	ra,40(sp)
    19dc:	f022                	sd	s0,32(sp)
    19de:	ec26                	sd	s1,24(sp)
    19e0:	e84a                	sd	s2,16(sp)
    19e2:	1800                	addi	s0,sp,48
    19e4:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
    19e8:	84aa                	mv	s1,a0
    19ea:	00000097          	auipc	ra,0x0
    19ee:	1b2080e7          	jalr	434(ra) # 1b9c <strlen>
    19f2:	1502                	slli	a0,a0,0x20
    19f4:	9101                	srli	a0,a0,0x20
    19f6:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
    19f8:	85a6                	mv	a1,s1
    19fa:	fd840513          	addi	a0,s0,-40
    19fe:	00000097          	auipc	ra,0x0
    1a02:	df6080e7          	jalr	-522(ra) # 17f4 <parseline>
    1a06:	892a                	mv	s2,a0
  peek(&s, es, "");
    1a08:	00001617          	auipc	a2,0x1
    1a0c:	95060613          	addi	a2,a2,-1712 # 2358 <malloc+0x1c8>
    1a10:	85a6                	mv	a1,s1
    1a12:	fd840513          	addi	a0,s0,-40
    1a16:	00000097          	auipc	ra,0x0
    1a1a:	b02080e7          	jalr	-1278(ra) # 1518 <peek>
  if(s != es){
    1a1e:	fd843603          	ld	a2,-40(s0)
    1a22:	00961e63          	bne	a2,s1,1a3e <parsecmd+0x66>
  nulterminate(cmd);
    1a26:	854a                	mv	a0,s2
    1a28:	00000097          	auipc	ra,0x0
    1a2c:	f18080e7          	jalr	-232(ra) # 1940 <nulterminate>
}
    1a30:	854a                	mv	a0,s2
    1a32:	70a2                	ld	ra,40(sp)
    1a34:	7402                	ld	s0,32(sp)
    1a36:	64e2                	ld	s1,24(sp)
    1a38:	6942                	ld	s2,16(sp)
    1a3a:	6145                	addi	sp,sp,48
    1a3c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
    1a3e:	00001597          	auipc	a1,0x1
    1a42:	92258593          	addi	a1,a1,-1758 # 2360 <malloc+0x1d0>
    1a46:	4509                	li	a0,2
    1a48:	00000097          	auipc	ra,0x0
    1a4c:	65c080e7          	jalr	1628(ra) # 20a4 <fprintf>
    panic("syntax");
    1a50:	00001517          	auipc	a0,0x1
    1a54:	8a050513          	addi	a0,a0,-1888 # 22f0 <malloc+0x160>
    1a58:	fffff097          	auipc	ra,0xfffff
    1a5c:	5fc080e7          	jalr	1532(ra) # 1054 <panic>

0000000000001a60 <main>:
{
    1a60:	7139                	addi	sp,sp,-64
    1a62:	fc06                	sd	ra,56(sp)
    1a64:	f822                	sd	s0,48(sp)
    1a66:	f426                	sd	s1,40(sp)
    1a68:	f04a                	sd	s2,32(sp)
    1a6a:	ec4e                	sd	s3,24(sp)
    1a6c:	e852                	sd	s4,16(sp)
    1a6e:	e456                	sd	s5,8(sp)
    1a70:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
    1a72:	00001497          	auipc	s1,0x1
    1a76:	8fe48493          	addi	s1,s1,-1794 # 2370 <malloc+0x1e0>
    1a7a:	4589                	li	a1,2
    1a7c:	8526                	mv	a0,s1
    1a7e:	00000097          	auipc	ra,0x0
    1a82:	30c080e7          	jalr	780(ra) # 1d8a <open>
    1a86:	00054963          	bltz	a0,1a98 <main+0x38>
    if(fd >= 3){
    1a8a:	4789                	li	a5,2
    1a8c:	fea7d7e3          	bge	a5,a0,1a7a <main+0x1a>
      close(fd);
    1a90:	00000097          	auipc	ra,0x0
    1a94:	2e2080e7          	jalr	738(ra) # 1d72 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
    1a98:	00001497          	auipc	s1,0x1
    1a9c:	95848493          	addi	s1,s1,-1704 # 23f0 <buf.1132>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    1aa0:	06300913          	li	s2,99
    1aa4:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
    1aa8:	00001a17          	auipc	s4,0x1
    1aac:	94ba0a13          	addi	s4,s4,-1717 # 23f3 <buf.1132+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
    1ab0:	00001a97          	auipc	s5,0x1
    1ab4:	8c8a8a93          	addi	s5,s5,-1848 # 2378 <malloc+0x1e8>
    1ab8:	a819                	j	1ace <main+0x6e>
    if(fork1() == 0)
    1aba:	fffff097          	auipc	ra,0xfffff
    1abe:	5c0080e7          	jalr	1472(ra) # 107a <fork1>
    1ac2:	c925                	beqz	a0,1b32 <main+0xd2>
    wait(0);
    1ac4:	4501                	li	a0,0
    1ac6:	00000097          	auipc	ra,0x0
    1aca:	28c080e7          	jalr	652(ra) # 1d52 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
    1ace:	06400593          	li	a1,100
    1ad2:	8526                	mv	a0,s1
    1ad4:	fffff097          	auipc	ra,0xfffff
    1ad8:	52c080e7          	jalr	1324(ra) # 1000 <getcmd>
    1adc:	06054763          	bltz	a0,1b4a <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    1ae0:	0004c783          	lbu	a5,0(s1)
    1ae4:	fd279be3          	bne	a5,s2,1aba <main+0x5a>
    1ae8:	0014c703          	lbu	a4,1(s1)
    1aec:	06400793          	li	a5,100
    1af0:	fcf715e3          	bne	a4,a5,1aba <main+0x5a>
    1af4:	0024c783          	lbu	a5,2(s1)
    1af8:	fd3791e3          	bne	a5,s3,1aba <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
    1afc:	8526                	mv	a0,s1
    1afe:	00000097          	auipc	ra,0x0
    1b02:	09e080e7          	jalr	158(ra) # 1b9c <strlen>
    1b06:	fff5079b          	addiw	a5,a0,-1
    1b0a:	1782                	slli	a5,a5,0x20
    1b0c:	9381                	srli	a5,a5,0x20
    1b0e:	97a6                	add	a5,a5,s1
    1b10:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
    1b14:	8552                	mv	a0,s4
    1b16:	00000097          	auipc	ra,0x0
    1b1a:	2a4080e7          	jalr	676(ra) # 1dba <chdir>
    1b1e:	fa0558e3          	bgez	a0,1ace <main+0x6e>
        fprintf(2, "cannot cd %s\n", buf+3);
    1b22:	8652                	mv	a2,s4
    1b24:	85d6                	mv	a1,s5
    1b26:	4509                	li	a0,2
    1b28:	00000097          	auipc	ra,0x0
    1b2c:	57c080e7          	jalr	1404(ra) # 20a4 <fprintf>
    1b30:	bf79                	j	1ace <main+0x6e>
      runcmd(parsecmd(buf));
    1b32:	00001517          	auipc	a0,0x1
    1b36:	8be50513          	addi	a0,a0,-1858 # 23f0 <buf.1132>
    1b3a:	00000097          	auipc	ra,0x0
    1b3e:	e9e080e7          	jalr	-354(ra) # 19d8 <parsecmd>
    1b42:	fffff097          	auipc	ra,0xfffff
    1b46:	566080e7          	jalr	1382(ra) # 10a8 <runcmd>
  exit(0);
    1b4a:	4501                	li	a0,0
    1b4c:	00000097          	auipc	ra,0x0
    1b50:	1fe080e7          	jalr	510(ra) # 1d4a <exit>

0000000000001b54 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    1b54:	1141                	addi	sp,sp,-16
    1b56:	e422                	sd	s0,8(sp)
    1b58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1b5a:	87aa                	mv	a5,a0
    1b5c:	0585                	addi	a1,a1,1
    1b5e:	0785                	addi	a5,a5,1
    1b60:	fff5c703          	lbu	a4,-1(a1)
    1b64:	fee78fa3          	sb	a4,-1(a5)
    1b68:	fb75                	bnez	a4,1b5c <strcpy+0x8>
    ;
  return os;
}
    1b6a:	6422                	ld	s0,8(sp)
    1b6c:	0141                	addi	sp,sp,16
    1b6e:	8082                	ret

0000000000001b70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1b70:	1141                	addi	sp,sp,-16
    1b72:	e422                	sd	s0,8(sp)
    1b74:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1b76:	00054783          	lbu	a5,0(a0)
    1b7a:	cb91                	beqz	a5,1b8e <strcmp+0x1e>
    1b7c:	0005c703          	lbu	a4,0(a1)
    1b80:	00f71763          	bne	a4,a5,1b8e <strcmp+0x1e>
    p++, q++;
    1b84:	0505                	addi	a0,a0,1
    1b86:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1b88:	00054783          	lbu	a5,0(a0)
    1b8c:	fbe5                	bnez	a5,1b7c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1b8e:	0005c503          	lbu	a0,0(a1)
}
    1b92:	40a7853b          	subw	a0,a5,a0
    1b96:	6422                	ld	s0,8(sp)
    1b98:	0141                	addi	sp,sp,16
    1b9a:	8082                	ret

0000000000001b9c <strlen>:

uint
strlen(const char *s)
{
    1b9c:	1141                	addi	sp,sp,-16
    1b9e:	e422                	sd	s0,8(sp)
    1ba0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1ba2:	00054783          	lbu	a5,0(a0)
    1ba6:	cf91                	beqz	a5,1bc2 <strlen+0x26>
    1ba8:	0505                	addi	a0,a0,1
    1baa:	87aa                	mv	a5,a0
    1bac:	4685                	li	a3,1
    1bae:	9e89                	subw	a3,a3,a0
    1bb0:	00f6853b          	addw	a0,a3,a5
    1bb4:	0785                	addi	a5,a5,1
    1bb6:	fff7c703          	lbu	a4,-1(a5)
    1bba:	fb7d                	bnez	a4,1bb0 <strlen+0x14>
    ;
  return n;
}
    1bbc:	6422                	ld	s0,8(sp)
    1bbe:	0141                	addi	sp,sp,16
    1bc0:	8082                	ret
  for(n = 0; s[n]; n++)
    1bc2:	4501                	li	a0,0
    1bc4:	bfe5                	j	1bbc <strlen+0x20>

0000000000001bc6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1bc6:	1141                	addi	sp,sp,-16
    1bc8:	e422                	sd	s0,8(sp)
    1bca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1bcc:	ce09                	beqz	a2,1be6 <memset+0x20>
    1bce:	87aa                	mv	a5,a0
    1bd0:	fff6071b          	addiw	a4,a2,-1
    1bd4:	1702                	slli	a4,a4,0x20
    1bd6:	9301                	srli	a4,a4,0x20
    1bd8:	0705                	addi	a4,a4,1
    1bda:	972a                	add	a4,a4,a0
    cdst[i] = c;
    1bdc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1be0:	0785                	addi	a5,a5,1
    1be2:	fee79de3          	bne	a5,a4,1bdc <memset+0x16>
  }
  return dst;
}
    1be6:	6422                	ld	s0,8(sp)
    1be8:	0141                	addi	sp,sp,16
    1bea:	8082                	ret

0000000000001bec <strchr>:

char*
strchr(const char *s, char c)
{
    1bec:	1141                	addi	sp,sp,-16
    1bee:	e422                	sd	s0,8(sp)
    1bf0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1bf2:	00054783          	lbu	a5,0(a0)
    1bf6:	cb99                	beqz	a5,1c0c <strchr+0x20>
    if(*s == c)
    1bf8:	00f58763          	beq	a1,a5,1c06 <strchr+0x1a>
  for(; *s; s++)
    1bfc:	0505                	addi	a0,a0,1
    1bfe:	00054783          	lbu	a5,0(a0)
    1c02:	fbfd                	bnez	a5,1bf8 <strchr+0xc>
      return (char*)s;
  return 0;
    1c04:	4501                	li	a0,0
}
    1c06:	6422                	ld	s0,8(sp)
    1c08:	0141                	addi	sp,sp,16
    1c0a:	8082                	ret
  return 0;
    1c0c:	4501                	li	a0,0
    1c0e:	bfe5                	j	1c06 <strchr+0x1a>

0000000000001c10 <gets>:

char*
gets(char *buf, int max)
{
    1c10:	711d                	addi	sp,sp,-96
    1c12:	ec86                	sd	ra,88(sp)
    1c14:	e8a2                	sd	s0,80(sp)
    1c16:	e4a6                	sd	s1,72(sp)
    1c18:	e0ca                	sd	s2,64(sp)
    1c1a:	fc4e                	sd	s3,56(sp)
    1c1c:	f852                	sd	s4,48(sp)
    1c1e:	f456                	sd	s5,40(sp)
    1c20:	f05a                	sd	s6,32(sp)
    1c22:	ec5e                	sd	s7,24(sp)
    1c24:	1080                	addi	s0,sp,96
    1c26:	8baa                	mv	s7,a0
    1c28:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1c2a:	892a                	mv	s2,a0
    1c2c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1c2e:	4aa9                	li	s5,10
    1c30:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1c32:	89a6                	mv	s3,s1
    1c34:	2485                	addiw	s1,s1,1
    1c36:	0344d863          	bge	s1,s4,1c66 <gets+0x56>
    cc = read(0, &c, 1);
    1c3a:	4605                	li	a2,1
    1c3c:	faf40593          	addi	a1,s0,-81
    1c40:	4501                	li	a0,0
    1c42:	00000097          	auipc	ra,0x0
    1c46:	120080e7          	jalr	288(ra) # 1d62 <read>
    if(cc < 1)
    1c4a:	00a05e63          	blez	a0,1c66 <gets+0x56>
    buf[i++] = c;
    1c4e:	faf44783          	lbu	a5,-81(s0)
    1c52:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1c56:	01578763          	beq	a5,s5,1c64 <gets+0x54>
    1c5a:	0905                	addi	s2,s2,1
    1c5c:	fd679be3          	bne	a5,s6,1c32 <gets+0x22>
  for(i=0; i+1 < max; ){
    1c60:	89a6                	mv	s3,s1
    1c62:	a011                	j	1c66 <gets+0x56>
    1c64:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1c66:	99de                	add	s3,s3,s7
    1c68:	00098023          	sb	zero,0(s3)
  return buf;
}
    1c6c:	855e                	mv	a0,s7
    1c6e:	60e6                	ld	ra,88(sp)
    1c70:	6446                	ld	s0,80(sp)
    1c72:	64a6                	ld	s1,72(sp)
    1c74:	6906                	ld	s2,64(sp)
    1c76:	79e2                	ld	s3,56(sp)
    1c78:	7a42                	ld	s4,48(sp)
    1c7a:	7aa2                	ld	s5,40(sp)
    1c7c:	7b02                	ld	s6,32(sp)
    1c7e:	6be2                	ld	s7,24(sp)
    1c80:	6125                	addi	sp,sp,96
    1c82:	8082                	ret

0000000000001c84 <stat>:

int
stat(const char *n, struct stat *st)
{
    1c84:	1101                	addi	sp,sp,-32
    1c86:	ec06                	sd	ra,24(sp)
    1c88:	e822                	sd	s0,16(sp)
    1c8a:	e426                	sd	s1,8(sp)
    1c8c:	e04a                	sd	s2,0(sp)
    1c8e:	1000                	addi	s0,sp,32
    1c90:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1c92:	4581                	li	a1,0
    1c94:	00000097          	auipc	ra,0x0
    1c98:	0f6080e7          	jalr	246(ra) # 1d8a <open>
  if(fd < 0)
    1c9c:	02054563          	bltz	a0,1cc6 <stat+0x42>
    1ca0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1ca2:	85ca                	mv	a1,s2
    1ca4:	00000097          	auipc	ra,0x0
    1ca8:	0fe080e7          	jalr	254(ra) # 1da2 <fstat>
    1cac:	892a                	mv	s2,a0
  close(fd);
    1cae:	8526                	mv	a0,s1
    1cb0:	00000097          	auipc	ra,0x0
    1cb4:	0c2080e7          	jalr	194(ra) # 1d72 <close>
  return r;
}
    1cb8:	854a                	mv	a0,s2
    1cba:	60e2                	ld	ra,24(sp)
    1cbc:	6442                	ld	s0,16(sp)
    1cbe:	64a2                	ld	s1,8(sp)
    1cc0:	6902                	ld	s2,0(sp)
    1cc2:	6105                	addi	sp,sp,32
    1cc4:	8082                	ret
    return -1;
    1cc6:	597d                	li	s2,-1
    1cc8:	bfc5                	j	1cb8 <stat+0x34>

0000000000001cca <atoi>:

int
atoi(const char *s)
{
    1cca:	1141                	addi	sp,sp,-16
    1ccc:	e422                	sd	s0,8(sp)
    1cce:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1cd0:	00054603          	lbu	a2,0(a0)
    1cd4:	fd06079b          	addiw	a5,a2,-48
    1cd8:	0ff7f793          	andi	a5,a5,255
    1cdc:	4725                	li	a4,9
    1cde:	02f76963          	bltu	a4,a5,1d10 <atoi+0x46>
    1ce2:	86aa                	mv	a3,a0
  n = 0;
    1ce4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    1ce6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    1ce8:	0685                	addi	a3,a3,1
    1cea:	0025179b          	slliw	a5,a0,0x2
    1cee:	9fa9                	addw	a5,a5,a0
    1cf0:	0017979b          	slliw	a5,a5,0x1
    1cf4:	9fb1                	addw	a5,a5,a2
    1cf6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1cfa:	0006c603          	lbu	a2,0(a3)
    1cfe:	fd06071b          	addiw	a4,a2,-48
    1d02:	0ff77713          	andi	a4,a4,255
    1d06:	fee5f1e3          	bgeu	a1,a4,1ce8 <atoi+0x1e>
  return n;
}
    1d0a:	6422                	ld	s0,8(sp)
    1d0c:	0141                	addi	sp,sp,16
    1d0e:	8082                	ret
  n = 0;
    1d10:	4501                	li	a0,0
    1d12:	bfe5                	j	1d0a <atoi+0x40>

0000000000001d14 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1d14:	1141                	addi	sp,sp,-16
    1d16:	e422                	sd	s0,8(sp)
    1d18:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1d1a:	02c05163          	blez	a2,1d3c <memmove+0x28>
    1d1e:	fff6071b          	addiw	a4,a2,-1
    1d22:	1702                	slli	a4,a4,0x20
    1d24:	9301                	srli	a4,a4,0x20
    1d26:	0705                	addi	a4,a4,1
    1d28:	972a                	add	a4,a4,a0
  dst = vdst;
    1d2a:	87aa                	mv	a5,a0
    *dst++ = *src++;
    1d2c:	0585                	addi	a1,a1,1
    1d2e:	0785                	addi	a5,a5,1
    1d30:	fff5c683          	lbu	a3,-1(a1)
    1d34:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    1d38:	fee79ae3          	bne	a5,a4,1d2c <memmove+0x18>
  return vdst;
}
    1d3c:	6422                	ld	s0,8(sp)
    1d3e:	0141                	addi	sp,sp,16
    1d40:	8082                	ret

0000000000001d42 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1d42:	4885                	li	a7,1
 ecall
    1d44:	00000073          	ecall
 ret
    1d48:	8082                	ret

0000000000001d4a <exit>:
.global exit
exit:
 li a7, SYS_exit
    1d4a:	4889                	li	a7,2
 ecall
    1d4c:	00000073          	ecall
 ret
    1d50:	8082                	ret

0000000000001d52 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1d52:	488d                	li	a7,3
 ecall
    1d54:	00000073          	ecall
 ret
    1d58:	8082                	ret

0000000000001d5a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1d5a:	4891                	li	a7,4
 ecall
    1d5c:	00000073          	ecall
 ret
    1d60:	8082                	ret

0000000000001d62 <read>:
.global read
read:
 li a7, SYS_read
    1d62:	4895                	li	a7,5
 ecall
    1d64:	00000073          	ecall
 ret
    1d68:	8082                	ret

0000000000001d6a <write>:
.global write
write:
 li a7, SYS_write
    1d6a:	48c1                	li	a7,16
 ecall
    1d6c:	00000073          	ecall
 ret
    1d70:	8082                	ret

0000000000001d72 <close>:
.global close
close:
 li a7, SYS_close
    1d72:	48d5                	li	a7,21
 ecall
    1d74:	00000073          	ecall
 ret
    1d78:	8082                	ret

0000000000001d7a <kill>:
.global kill
kill:
 li a7, SYS_kill
    1d7a:	4899                	li	a7,6
 ecall
    1d7c:	00000073          	ecall
 ret
    1d80:	8082                	ret

0000000000001d82 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1d82:	489d                	li	a7,7
 ecall
    1d84:	00000073          	ecall
 ret
    1d88:	8082                	ret

0000000000001d8a <open>:
.global open
open:
 li a7, SYS_open
    1d8a:	48bd                	li	a7,15
 ecall
    1d8c:	00000073          	ecall
 ret
    1d90:	8082                	ret

0000000000001d92 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1d92:	48c5                	li	a7,17
 ecall
    1d94:	00000073          	ecall
 ret
    1d98:	8082                	ret

0000000000001d9a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1d9a:	48c9                	li	a7,18
 ecall
    1d9c:	00000073          	ecall
 ret
    1da0:	8082                	ret

0000000000001da2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1da2:	48a1                	li	a7,8
 ecall
    1da4:	00000073          	ecall
 ret
    1da8:	8082                	ret

0000000000001daa <link>:
.global link
link:
 li a7, SYS_link
    1daa:	48cd                	li	a7,19
 ecall
    1dac:	00000073          	ecall
 ret
    1db0:	8082                	ret

0000000000001db2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1db2:	48d1                	li	a7,20
 ecall
    1db4:	00000073          	ecall
 ret
    1db8:	8082                	ret

0000000000001dba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1dba:	48a5                	li	a7,9
 ecall
    1dbc:	00000073          	ecall
 ret
    1dc0:	8082                	ret

0000000000001dc2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1dc2:	48a9                	li	a7,10
 ecall
    1dc4:	00000073          	ecall
 ret
    1dc8:	8082                	ret

0000000000001dca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1dca:	48ad                	li	a7,11
 ecall
    1dcc:	00000073          	ecall
 ret
    1dd0:	8082                	ret

0000000000001dd2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1dd2:	48b1                	li	a7,12
 ecall
    1dd4:	00000073          	ecall
 ret
    1dd8:	8082                	ret

0000000000001dda <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1dda:	48b5                	li	a7,13
 ecall
    1ddc:	00000073          	ecall
 ret
    1de0:	8082                	ret

0000000000001de2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1de2:	48b9                	li	a7,14
 ecall
    1de4:	00000073          	ecall
 ret
    1de8:	8082                	ret

0000000000001dea <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    1dea:	48d9                	li	a7,22
 ecall
    1dec:	00000073          	ecall
 ret
    1df0:	8082                	ret

0000000000001df2 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    1df2:	48dd                	li	a7,23
 ecall
    1df4:	00000073          	ecall
 ret
    1df8:	8082                	ret

0000000000001dfa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1dfa:	1101                	addi	sp,sp,-32
    1dfc:	ec06                	sd	ra,24(sp)
    1dfe:	e822                	sd	s0,16(sp)
    1e00:	1000                	addi	s0,sp,32
    1e02:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1e06:	4605                	li	a2,1
    1e08:	fef40593          	addi	a1,s0,-17
    1e0c:	00000097          	auipc	ra,0x0
    1e10:	f5e080e7          	jalr	-162(ra) # 1d6a <write>
}
    1e14:	60e2                	ld	ra,24(sp)
    1e16:	6442                	ld	s0,16(sp)
    1e18:	6105                	addi	sp,sp,32
    1e1a:	8082                	ret

0000000000001e1c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1e1c:	7139                	addi	sp,sp,-64
    1e1e:	fc06                	sd	ra,56(sp)
    1e20:	f822                	sd	s0,48(sp)
    1e22:	f426                	sd	s1,40(sp)
    1e24:	f04a                	sd	s2,32(sp)
    1e26:	ec4e                	sd	s3,24(sp)
    1e28:	0080                	addi	s0,sp,64
    1e2a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1e2c:	c299                	beqz	a3,1e32 <printint+0x16>
    1e2e:	0805c863          	bltz	a1,1ebe <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1e32:	2581                	sext.w	a1,a1
  neg = 0;
    1e34:	4881                	li	a7,0
    1e36:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1e3a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1e3c:	2601                	sext.w	a2,a2
    1e3e:	00000517          	auipc	a0,0x0
    1e42:	58250513          	addi	a0,a0,1410 # 23c0 <digits>
    1e46:	883a                	mv	a6,a4
    1e48:	2705                	addiw	a4,a4,1
    1e4a:	02c5f7bb          	remuw	a5,a1,a2
    1e4e:	1782                	slli	a5,a5,0x20
    1e50:	9381                	srli	a5,a5,0x20
    1e52:	97aa                	add	a5,a5,a0
    1e54:	0007c783          	lbu	a5,0(a5)
    1e58:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1e5c:	0005879b          	sext.w	a5,a1
    1e60:	02c5d5bb          	divuw	a1,a1,a2
    1e64:	0685                	addi	a3,a3,1
    1e66:	fec7f0e3          	bgeu	a5,a2,1e46 <printint+0x2a>
  if(neg)
    1e6a:	00088b63          	beqz	a7,1e80 <printint+0x64>
    buf[i++] = '-';
    1e6e:	fd040793          	addi	a5,s0,-48
    1e72:	973e                	add	a4,a4,a5
    1e74:	02d00793          	li	a5,45
    1e78:	fef70823          	sb	a5,-16(a4)
    1e7c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1e80:	02e05863          	blez	a4,1eb0 <printint+0x94>
    1e84:	fc040793          	addi	a5,s0,-64
    1e88:	00e78933          	add	s2,a5,a4
    1e8c:	fff78993          	addi	s3,a5,-1
    1e90:	99ba                	add	s3,s3,a4
    1e92:	377d                	addiw	a4,a4,-1
    1e94:	1702                	slli	a4,a4,0x20
    1e96:	9301                	srli	a4,a4,0x20
    1e98:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1e9c:	fff94583          	lbu	a1,-1(s2)
    1ea0:	8526                	mv	a0,s1
    1ea2:	00000097          	auipc	ra,0x0
    1ea6:	f58080e7          	jalr	-168(ra) # 1dfa <putc>
  while(--i >= 0)
    1eaa:	197d                	addi	s2,s2,-1
    1eac:	ff3918e3          	bne	s2,s3,1e9c <printint+0x80>
}
    1eb0:	70e2                	ld	ra,56(sp)
    1eb2:	7442                	ld	s0,48(sp)
    1eb4:	74a2                	ld	s1,40(sp)
    1eb6:	7902                	ld	s2,32(sp)
    1eb8:	69e2                	ld	s3,24(sp)
    1eba:	6121                	addi	sp,sp,64
    1ebc:	8082                	ret
    x = -xx;
    1ebe:	40b005bb          	negw	a1,a1
    neg = 1;
    1ec2:	4885                	li	a7,1
    x = -xx;
    1ec4:	bf8d                	j	1e36 <printint+0x1a>

0000000000001ec6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1ec6:	7119                	addi	sp,sp,-128
    1ec8:	fc86                	sd	ra,120(sp)
    1eca:	f8a2                	sd	s0,112(sp)
    1ecc:	f4a6                	sd	s1,104(sp)
    1ece:	f0ca                	sd	s2,96(sp)
    1ed0:	ecce                	sd	s3,88(sp)
    1ed2:	e8d2                	sd	s4,80(sp)
    1ed4:	e4d6                	sd	s5,72(sp)
    1ed6:	e0da                	sd	s6,64(sp)
    1ed8:	fc5e                	sd	s7,56(sp)
    1eda:	f862                	sd	s8,48(sp)
    1edc:	f466                	sd	s9,40(sp)
    1ede:	f06a                	sd	s10,32(sp)
    1ee0:	ec6e                	sd	s11,24(sp)
    1ee2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1ee4:	0005c903          	lbu	s2,0(a1)
    1ee8:	18090f63          	beqz	s2,2086 <vprintf+0x1c0>
    1eec:	8aaa                	mv	s5,a0
    1eee:	8b32                	mv	s6,a2
    1ef0:	00158493          	addi	s1,a1,1
  state = 0;
    1ef4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1ef6:	02500a13          	li	s4,37
      if(c == 'd'){
    1efa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1efe:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1f02:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1f06:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1f0a:	00000b97          	auipc	s7,0x0
    1f0e:	4b6b8b93          	addi	s7,s7,1206 # 23c0 <digits>
    1f12:	a839                	j	1f30 <vprintf+0x6a>
        putc(fd, c);
    1f14:	85ca                	mv	a1,s2
    1f16:	8556                	mv	a0,s5
    1f18:	00000097          	auipc	ra,0x0
    1f1c:	ee2080e7          	jalr	-286(ra) # 1dfa <putc>
    1f20:	a019                	j	1f26 <vprintf+0x60>
    } else if(state == '%'){
    1f22:	01498f63          	beq	s3,s4,1f40 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1f26:	0485                	addi	s1,s1,1
    1f28:	fff4c903          	lbu	s2,-1(s1)
    1f2c:	14090d63          	beqz	s2,2086 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1f30:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1f34:	fe0997e3          	bnez	s3,1f22 <vprintf+0x5c>
      if(c == '%'){
    1f38:	fd479ee3          	bne	a5,s4,1f14 <vprintf+0x4e>
        state = '%';
    1f3c:	89be                	mv	s3,a5
    1f3e:	b7e5                	j	1f26 <vprintf+0x60>
      if(c == 'd'){
    1f40:	05878063          	beq	a5,s8,1f80 <vprintf+0xba>
      } else if(c == 'l') {
    1f44:	05978c63          	beq	a5,s9,1f9c <vprintf+0xd6>
      } else if(c == 'x') {
    1f48:	07a78863          	beq	a5,s10,1fb8 <vprintf+0xf2>
      } else if(c == 'p') {
    1f4c:	09b78463          	beq	a5,s11,1fd4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1f50:	07300713          	li	a4,115
    1f54:	0ce78663          	beq	a5,a4,2020 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1f58:	06300713          	li	a4,99
    1f5c:	0ee78e63          	beq	a5,a4,2058 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1f60:	11478863          	beq	a5,s4,2070 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1f64:	85d2                	mv	a1,s4
    1f66:	8556                	mv	a0,s5
    1f68:	00000097          	auipc	ra,0x0
    1f6c:	e92080e7          	jalr	-366(ra) # 1dfa <putc>
        putc(fd, c);
    1f70:	85ca                	mv	a1,s2
    1f72:	8556                	mv	a0,s5
    1f74:	00000097          	auipc	ra,0x0
    1f78:	e86080e7          	jalr	-378(ra) # 1dfa <putc>
      }
      state = 0;
    1f7c:	4981                	li	s3,0
    1f7e:	b765                	j	1f26 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1f80:	008b0913          	addi	s2,s6,8
    1f84:	4685                	li	a3,1
    1f86:	4629                	li	a2,10
    1f88:	000b2583          	lw	a1,0(s6)
    1f8c:	8556                	mv	a0,s5
    1f8e:	00000097          	auipc	ra,0x0
    1f92:	e8e080e7          	jalr	-370(ra) # 1e1c <printint>
    1f96:	8b4a                	mv	s6,s2
      state = 0;
    1f98:	4981                	li	s3,0
    1f9a:	b771                	j	1f26 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1f9c:	008b0913          	addi	s2,s6,8
    1fa0:	4681                	li	a3,0
    1fa2:	4629                	li	a2,10
    1fa4:	000b2583          	lw	a1,0(s6)
    1fa8:	8556                	mv	a0,s5
    1faa:	00000097          	auipc	ra,0x0
    1fae:	e72080e7          	jalr	-398(ra) # 1e1c <printint>
    1fb2:	8b4a                	mv	s6,s2
      state = 0;
    1fb4:	4981                	li	s3,0
    1fb6:	bf85                	j	1f26 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1fb8:	008b0913          	addi	s2,s6,8
    1fbc:	4681                	li	a3,0
    1fbe:	4641                	li	a2,16
    1fc0:	000b2583          	lw	a1,0(s6)
    1fc4:	8556                	mv	a0,s5
    1fc6:	00000097          	auipc	ra,0x0
    1fca:	e56080e7          	jalr	-426(ra) # 1e1c <printint>
    1fce:	8b4a                	mv	s6,s2
      state = 0;
    1fd0:	4981                	li	s3,0
    1fd2:	bf91                	j	1f26 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1fd4:	008b0793          	addi	a5,s6,8
    1fd8:	f8f43423          	sd	a5,-120(s0)
    1fdc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1fe0:	03000593          	li	a1,48
    1fe4:	8556                	mv	a0,s5
    1fe6:	00000097          	auipc	ra,0x0
    1fea:	e14080e7          	jalr	-492(ra) # 1dfa <putc>
  putc(fd, 'x');
    1fee:	85ea                	mv	a1,s10
    1ff0:	8556                	mv	a0,s5
    1ff2:	00000097          	auipc	ra,0x0
    1ff6:	e08080e7          	jalr	-504(ra) # 1dfa <putc>
    1ffa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1ffc:	03c9d793          	srli	a5,s3,0x3c
    2000:	97de                	add	a5,a5,s7
    2002:	0007c583          	lbu	a1,0(a5)
    2006:	8556                	mv	a0,s5
    2008:	00000097          	auipc	ra,0x0
    200c:	df2080e7          	jalr	-526(ra) # 1dfa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    2010:	0992                	slli	s3,s3,0x4
    2012:	397d                	addiw	s2,s2,-1
    2014:	fe0914e3          	bnez	s2,1ffc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    2018:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    201c:	4981                	li	s3,0
    201e:	b721                	j	1f26 <vprintf+0x60>
        s = va_arg(ap, char*);
    2020:	008b0993          	addi	s3,s6,8
    2024:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    2028:	02090163          	beqz	s2,204a <vprintf+0x184>
        while(*s != 0){
    202c:	00094583          	lbu	a1,0(s2)
    2030:	c9a1                	beqz	a1,2080 <vprintf+0x1ba>
          putc(fd, *s);
    2032:	8556                	mv	a0,s5
    2034:	00000097          	auipc	ra,0x0
    2038:	dc6080e7          	jalr	-570(ra) # 1dfa <putc>
          s++;
    203c:	0905                	addi	s2,s2,1
        while(*s != 0){
    203e:	00094583          	lbu	a1,0(s2)
    2042:	f9e5                	bnez	a1,2032 <vprintf+0x16c>
        s = va_arg(ap, char*);
    2044:	8b4e                	mv	s6,s3
      state = 0;
    2046:	4981                	li	s3,0
    2048:	bdf9                	j	1f26 <vprintf+0x60>
          s = "(null)";
    204a:	00000917          	auipc	s2,0x0
    204e:	36e90913          	addi	s2,s2,878 # 23b8 <malloc+0x228>
        while(*s != 0){
    2052:	02800593          	li	a1,40
    2056:	bff1                	j	2032 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    2058:	008b0913          	addi	s2,s6,8
    205c:	000b4583          	lbu	a1,0(s6)
    2060:	8556                	mv	a0,s5
    2062:	00000097          	auipc	ra,0x0
    2066:	d98080e7          	jalr	-616(ra) # 1dfa <putc>
    206a:	8b4a                	mv	s6,s2
      state = 0;
    206c:	4981                	li	s3,0
    206e:	bd65                	j	1f26 <vprintf+0x60>
        putc(fd, c);
    2070:	85d2                	mv	a1,s4
    2072:	8556                	mv	a0,s5
    2074:	00000097          	auipc	ra,0x0
    2078:	d86080e7          	jalr	-634(ra) # 1dfa <putc>
      state = 0;
    207c:	4981                	li	s3,0
    207e:	b565                	j	1f26 <vprintf+0x60>
        s = va_arg(ap, char*);
    2080:	8b4e                	mv	s6,s3
      state = 0;
    2082:	4981                	li	s3,0
    2084:	b54d                	j	1f26 <vprintf+0x60>
    }
  }
}
    2086:	70e6                	ld	ra,120(sp)
    2088:	7446                	ld	s0,112(sp)
    208a:	74a6                	ld	s1,104(sp)
    208c:	7906                	ld	s2,96(sp)
    208e:	69e6                	ld	s3,88(sp)
    2090:	6a46                	ld	s4,80(sp)
    2092:	6aa6                	ld	s5,72(sp)
    2094:	6b06                	ld	s6,64(sp)
    2096:	7be2                	ld	s7,56(sp)
    2098:	7c42                	ld	s8,48(sp)
    209a:	7ca2                	ld	s9,40(sp)
    209c:	7d02                	ld	s10,32(sp)
    209e:	6de2                	ld	s11,24(sp)
    20a0:	6109                	addi	sp,sp,128
    20a2:	8082                	ret

00000000000020a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    20a4:	715d                	addi	sp,sp,-80
    20a6:	ec06                	sd	ra,24(sp)
    20a8:	e822                	sd	s0,16(sp)
    20aa:	1000                	addi	s0,sp,32
    20ac:	e010                	sd	a2,0(s0)
    20ae:	e414                	sd	a3,8(s0)
    20b0:	e818                	sd	a4,16(s0)
    20b2:	ec1c                	sd	a5,24(s0)
    20b4:	03043023          	sd	a6,32(s0)
    20b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    20bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    20c0:	8622                	mv	a2,s0
    20c2:	00000097          	auipc	ra,0x0
    20c6:	e04080e7          	jalr	-508(ra) # 1ec6 <vprintf>
}
    20ca:	60e2                	ld	ra,24(sp)
    20cc:	6442                	ld	s0,16(sp)
    20ce:	6161                	addi	sp,sp,80
    20d0:	8082                	ret

00000000000020d2 <printf>:

void
printf(const char *fmt, ...)
{
    20d2:	711d                	addi	sp,sp,-96
    20d4:	ec06                	sd	ra,24(sp)
    20d6:	e822                	sd	s0,16(sp)
    20d8:	1000                	addi	s0,sp,32
    20da:	e40c                	sd	a1,8(s0)
    20dc:	e810                	sd	a2,16(s0)
    20de:	ec14                	sd	a3,24(s0)
    20e0:	f018                	sd	a4,32(s0)
    20e2:	f41c                	sd	a5,40(s0)
    20e4:	03043823          	sd	a6,48(s0)
    20e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    20ec:	00840613          	addi	a2,s0,8
    20f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    20f4:	85aa                	mv	a1,a0
    20f6:	4505                	li	a0,1
    20f8:	00000097          	auipc	ra,0x0
    20fc:	dce080e7          	jalr	-562(ra) # 1ec6 <vprintf>
}
    2100:	60e2                	ld	ra,24(sp)
    2102:	6442                	ld	s0,16(sp)
    2104:	6125                	addi	sp,sp,96
    2106:	8082                	ret

0000000000002108 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2108:	1141                	addi	sp,sp,-16
    210a:	e422                	sd	s0,8(sp)
    210c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    210e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2112:	00000797          	auipc	a5,0x0
    2116:	2d67b783          	ld	a5,726(a5) # 23e8 <freep>
    211a:	a805                	j	214a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    211c:	4618                	lw	a4,8(a2)
    211e:	9db9                	addw	a1,a1,a4
    2120:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    2124:	6398                	ld	a4,0(a5)
    2126:	6318                	ld	a4,0(a4)
    2128:	fee53823          	sd	a4,-16(a0)
    212c:	a091                	j	2170 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    212e:	ff852703          	lw	a4,-8(a0)
    2132:	9e39                	addw	a2,a2,a4
    2134:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    2136:	ff053703          	ld	a4,-16(a0)
    213a:	e398                	sd	a4,0(a5)
    213c:	a099                	j	2182 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    213e:	6398                	ld	a4,0(a5)
    2140:	00e7e463          	bltu	a5,a4,2148 <free+0x40>
    2144:	00e6ea63          	bltu	a3,a4,2158 <free+0x50>
{
    2148:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    214a:	fed7fae3          	bgeu	a5,a3,213e <free+0x36>
    214e:	6398                	ld	a4,0(a5)
    2150:	00e6e463          	bltu	a3,a4,2158 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2154:	fee7eae3          	bltu	a5,a4,2148 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    2158:	ff852583          	lw	a1,-8(a0)
    215c:	6390                	ld	a2,0(a5)
    215e:	02059713          	slli	a4,a1,0x20
    2162:	9301                	srli	a4,a4,0x20
    2164:	0712                	slli	a4,a4,0x4
    2166:	9736                	add	a4,a4,a3
    2168:	fae60ae3          	beq	a2,a4,211c <free+0x14>
    bp->s.ptr = p->s.ptr;
    216c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    2170:	4790                	lw	a2,8(a5)
    2172:	02061713          	slli	a4,a2,0x20
    2176:	9301                	srli	a4,a4,0x20
    2178:	0712                	slli	a4,a4,0x4
    217a:	973e                	add	a4,a4,a5
    217c:	fae689e3          	beq	a3,a4,212e <free+0x26>
  } else
    p->s.ptr = bp;
    2180:	e394                	sd	a3,0(a5)
  freep = p;
    2182:	00000717          	auipc	a4,0x0
    2186:	26f73323          	sd	a5,614(a4) # 23e8 <freep>
}
    218a:	6422                	ld	s0,8(sp)
    218c:	0141                	addi	sp,sp,16
    218e:	8082                	ret

0000000000002190 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    2190:	7139                	addi	sp,sp,-64
    2192:	fc06                	sd	ra,56(sp)
    2194:	f822                	sd	s0,48(sp)
    2196:	f426                	sd	s1,40(sp)
    2198:	f04a                	sd	s2,32(sp)
    219a:	ec4e                	sd	s3,24(sp)
    219c:	e852                	sd	s4,16(sp)
    219e:	e456                	sd	s5,8(sp)
    21a0:	e05a                	sd	s6,0(sp)
    21a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    21a4:	02051493          	slli	s1,a0,0x20
    21a8:	9081                	srli	s1,s1,0x20
    21aa:	04bd                	addi	s1,s1,15
    21ac:	8091                	srli	s1,s1,0x4
    21ae:	0014899b          	addiw	s3,s1,1
    21b2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    21b4:	00000517          	auipc	a0,0x0
    21b8:	23453503          	ld	a0,564(a0) # 23e8 <freep>
    21bc:	c515                	beqz	a0,21e8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    21c0:	4798                	lw	a4,8(a5)
    21c2:	02977f63          	bgeu	a4,s1,2200 <malloc+0x70>
    21c6:	8a4e                	mv	s4,s3
    21c8:	0009871b          	sext.w	a4,s3
    21cc:	6685                	lui	a3,0x1
    21ce:	00d77363          	bgeu	a4,a3,21d4 <malloc+0x44>
    21d2:	6a05                	lui	s4,0x1
    21d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    21d8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    21dc:	00000917          	auipc	s2,0x0
    21e0:	20c90913          	addi	s2,s2,524 # 23e8 <freep>
  if(p == (char*)-1)
    21e4:	5afd                	li	s5,-1
    21e6:	a88d                	j	2258 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    21e8:	00000797          	auipc	a5,0x0
    21ec:	27078793          	addi	a5,a5,624 # 2458 <base>
    21f0:	00000717          	auipc	a4,0x0
    21f4:	1ef73c23          	sd	a5,504(a4) # 23e8 <freep>
    21f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    21fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    21fe:	b7e1                	j	21c6 <malloc+0x36>
      if(p->s.size == nunits)
    2200:	02e48b63          	beq	s1,a4,2236 <malloc+0xa6>
        p->s.size -= nunits;
    2204:	4137073b          	subw	a4,a4,s3
    2208:	c798                	sw	a4,8(a5)
        p += p->s.size;
    220a:	1702                	slli	a4,a4,0x20
    220c:	9301                	srli	a4,a4,0x20
    220e:	0712                	slli	a4,a4,0x4
    2210:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    2212:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    2216:	00000717          	auipc	a4,0x0
    221a:	1ca73923          	sd	a0,466(a4) # 23e8 <freep>
      return (void*)(p + 1);
    221e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    2222:	70e2                	ld	ra,56(sp)
    2224:	7442                	ld	s0,48(sp)
    2226:	74a2                	ld	s1,40(sp)
    2228:	7902                	ld	s2,32(sp)
    222a:	69e2                	ld	s3,24(sp)
    222c:	6a42                	ld	s4,16(sp)
    222e:	6aa2                	ld	s5,8(sp)
    2230:	6b02                	ld	s6,0(sp)
    2232:	6121                	addi	sp,sp,64
    2234:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    2236:	6398                	ld	a4,0(a5)
    2238:	e118                	sd	a4,0(a0)
    223a:	bff1                	j	2216 <malloc+0x86>
  hp->s.size = nu;
    223c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    2240:	0541                	addi	a0,a0,16
    2242:	00000097          	auipc	ra,0x0
    2246:	ec6080e7          	jalr	-314(ra) # 2108 <free>
  return freep;
    224a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    224e:	d971                	beqz	a0,2222 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2250:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    2252:	4798                	lw	a4,8(a5)
    2254:	fa9776e3          	bgeu	a4,s1,2200 <malloc+0x70>
    if(p == freep)
    2258:	00093703          	ld	a4,0(s2)
    225c:	853e                	mv	a0,a5
    225e:	fef719e3          	bne	a4,a5,2250 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    2262:	8552                	mv	a0,s4
    2264:	00000097          	auipc	ra,0x0
    2268:	b6e080e7          	jalr	-1170(ra) # 1dd2 <sbrk>
  if(p == (char*)-1)
    226c:	fd5518e3          	bne	a0,s5,223c <malloc+0xac>
        return 0;
    2270:	4501                	li	a0,0
    2272:	bf45                	j	2222 <malloc+0x92>
