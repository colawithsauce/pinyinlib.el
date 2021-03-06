;;; pinyinlib.el --- Convert first letter of Pinyin to Simplified/Traditional Chinese characters  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Junpeng Qiu

;; Author: Junpeng Qiu <qjpchmail@gmail.com>
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;                              ______________

;;                               PINYINLIB.EL

;;                               Junpeng Qiu
;;                              ______________


;; Table of Contents
;; _________________

;; 1 Functions
;; .. 1.1 `pinyinlib-build-regexp-char'
;; .. 1.2 `pinyinlib-build-regexp-string'
;; 2 Packages that Use This Library
;; 3 Acknowledgment
;; 4 Contribute


;; [[file:https://melpa.org/packages/pinyinlib-badge.svg]]
;; [[file:https://stable.melpa.org/packages/pinyinlib-badge.svg]]

;; Library for converting first letter of Pinyin to Simplified/Traditional
;; Chinese characters.


;; [[file:https://melpa.org/packages/pinyinlib-badge.svg]]
;; https://melpa.org/#/pinyinlib

;; [[file:https://stable.melpa.org/packages/pinyinlib-badge.svg]]
;; https://stable.melpa.org/#/pinyinlib


;; 1 Functions
;; ===========

;; 1.1 `pinyinlib-build-regexp-char'
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;   `pinyinlib-build-regexp-char' converts a letter to a regular
;;   expression containing all the Chinese characters whose pinyins start
;;   with the letter.  It accepts five parameters:
;;   ,----
;;   | char &optional no-punc-p tranditional-p only-chinese-p mixed-p
;;   `----

;;   The first parameter `char' is the letter to be converted.  The latter
;;   four parameters are optional.
;;   - If `no-punc-p' is `t': it will not convert English punctuations to
;;     Chinese punctuations.

;;   - If `traditional-p' is `t': traditional Chinese characters are used
;;     instead of simplified Chinese characters.

;;   - If `only-chinese-p' is `t': the resulting regular expression doesn't
;;     contain the English letter `char'.

;;   - If `mixed-p' is `t': the resulting regular expression will mix
;;     traditional and simplified Chinese characters. This parameter will take
;;     precedence over `traditional-p'.

;;   When converting English punctuactions to Chinese/English punctuations,
;;   it uses the following table:
;;    English Punctuation  Chinese & English Punctuations 
;;   -----------------------------------------------------
;;    .                    。.                            
;;    ,                    ，,                            
;;    ?                    ？?                            
;;    :                    ：:                            
;;    !                    ！!                            
;;    ;                    ；;                            
;;    \\                   、\\                           
;;    (                    （(                            
;;    )                    ）)                            
;;    <                    《<                            
;;    >                    》>                            
;;    ~                    ～~                            
;;    '                    ‘’「」'                      
;;    "                    “”『』\"                     
;;    *                    ×*                            
;;    $                    ￥$                            


;; 1.2 `pinyinlib-build-regexp-string'
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;   It is same as `pinyinlib-build-regexp-char', except that its first
;;   parameter is a string so that it can convert a sequence of letters to
;;   a regular expression.


;; 2 Packages that Use This Library
;; ================================

;;   - [ace-pinyin]
;;   - [evil-find-char-pinyin]
;;   - [find-by-pinyin-dired]
;;   - [pinyin-search]


;; [ace-pinyin] https://github.com/cute-jumper/ace-pinyin

;; [evil-find-char-pinyin]
;; https://github.com/cute-jumper/evil-find-char-pinyin

;; [find-by-pinyin-dired]
;; https://github.com/redguardtoo/find-by-pinyin-dired

;; [pinyin-search] https://github.com/xuchunyang/pinyin-search.el


;; 3 Acknowledgment
;; ================

;;   - The ASCII char to Chinese character
;;     table(`pinyinlib--simplified-char-table' in code) is from
;;     [https://github.com/redguardtoo/find-by-pinyin-dired].
;;   - @erstern adds the table for traditional Chinese characters.


;; 4 Contribute
;; ============

;;   Contributions are always welcome.  If you want to add some common
;;   pinyin related functions that might be useful for other packages,
;;   please send me a PR.

;;; Code:

(defconst pinyinlib--simplified-char-table
  '("艾蔼鞍芭靶茇菝蒡薄苞葆蓓鞴萆苯蔽萆薜蓖荸芘荜鞭苄匾薄菠菜蔡藏苍草茶茬蒇菖苌臣茌茺莼茨茈葱苁蔟萃鞑靼甙萏荡菪蒂荻东董鸫蔸芏苊萼莪蒽贰范藩蕃蘩芳菲匪芾芬葑芙芾苻茯莩菔苷藁革戈葛茛工共功攻贡恭巩汞苟觏鞲遘菇菰莞鹳匦菡巷蒿薅荷菏蘅薨蕻荭葫花划萑黄荒荟茴蕙荤或获惑劐藿藉蓟荠蒺芨蕺芰茄荚葭荐茧菅鞯蒹蒋匠茳蕉艽茭节戒藉芥靳觐堇荩警敬荆茎菁巨菊鞠苴鞫苣莒蕨菌蒈莰苛恐蔻芤苦蒯匡葵匮蒉莱蓝莨蒗劳勒蕾莉莅藜荔苈藓蓠莲蔹莨蓼蔺菱苓茏蒌芦蓼落萝荦荬蔓颟鞔茫芒莽茅茂茆莓蒙萌瞢甍蘼苗藐鹋蔑苠茗莫蓦蘑茉摹幕慕墓募暮苜艿萘匿慝廿蔫茑孽蘖苎欧殴鸥瓯藕葩蒎蓬匹芘莩苤萍苹叵葡蒲菩莆七萋芪荠芑萁蕲葺葜芊荨芡蔷巧翘鞘荞鞒切茄勤芹芩擎苘檠茕邛蛩跫銎区蕖蘧苣颧荃鹊苒荛惹葚荏荣蓉戎茸鞣茹薷蓐芮蕤蕊若萨散莎芟苫苕鞘芍莘葚世式蓍莳贳薯蔬戍菽蒴菘薮苏蔌蒜荽荪蓑苔薹萄忒慝忒藤荑苕萜莛葶茼荼菟忒莞芄菀蔚萎苇薇葳蓊蕹卧莴巫芜芴昔熙茜觋菥葸蓰匣莶藓苋项巷葙芗萧鞋邪薤薪芯荇荥芎蓄蓿萱靴薛荤荀薰蕈雅牙鸦芽迓燕芫郾菸鞅药尧医艺艾颐弋薏荑苡翳茵荫鄞茚英营莹荧萤萦莺茔荥蓥莠莜莸萸芋菀蓣苑芫鸢蕴芸匝藏葬臧藻赜蘸蔗蓁蒸芝芷荮著茱苎茁茈菹蕞"
    "阿隘阪孢陂陛陈承丞耻蚩出除陲聪耽聃阽耵陡队堕耳防附尕陔戤隔耿孤聒孩函隍隳及际亟降阶孑卺阱聚孓孔聩隗了联了聊辽陵聆陆隆陇陋陆孟勐陌乃鼐聂陧颞聍陪皮陂陴聘颇陂亟阡取娶孺阮陕随祟隧隋孙陶粜陀卫隈隗阢隙隰险限陷降陉逊阽阳也耶隐阴盈隅院孕陨障阵职陟骘坠子孜陬鄹阻阼"
    "巴畚弁骠驳参骖参叉骣骋驰骢皴怠迨骀邓叠犊对怼驮驸颈牿牯观骇骅欢鸡骥犄艰犍骄劲矜颈迳刭驹犋骏犒骒垒骊骝驴骆骡马矛牦蟊蝥瞀鍪牧牟牡难能骗犏骈骠牝骑骐犍巯驱劝逡柔叁毵桑颡骚骟参圣牲驶双驷厶台邰骀炱特通驼驮物鹜骛牾婺戏牺骧骁熊驯验以矣驿勇恿甬又预予豫驭鹬允驵蚤骤驻骓驺"
    "碍砹鹌百帮邦磅碑碚奔夯甭泵砭碥飙髟鬓礴布礤厕碴厂砗辰碜成盛舂础厨春唇蠢磁蹙存磋厝大达耷砀磴砥碲碘碉碟碇硐碓礅砘夺厄而鸸砝矾奋丰奉砜否砩尬感尴矸硌龚故古顾辜鸪嘏硅磙还夯厚胡鹕瓠砉还鬟磺灰慧彗基奇矶髻剞戛嘏恝碱硷礓礁碣兢厩鬏厥劂砍勘戡克磕刳夸矿夼盔奎髡砬磊历励厉厘砺砾奁鹩尥鬣磷碌硫龙聋垄砻碌硌码硭髦礞面奈耐孬硇碾恧磅匏碰砰硼否丕砒邳破其期奇欺戚契砌欹綦碛牵鬈硗砌挈秦戌磲犬鬈确髯辱三磉厦砂髟奢厍甚蜃砷盛石寿耍爽硕斯肆厮碎太态泰碳套焘髫厅砼砣歪碗尢威硪戊袭矽硒夏厦硖咸厢硝硎雄髹戌砉碹压砑研厌雁艳奄砚赝餍魇厣页靥欹硬友右尤尢郁原愿砸在仄砟丈磔斟砧碡砖斫髭鬃奏左"
    "腌爱胺肮办膀胞豹边膘膑脖膊采彩豺肠塍膪腠爨脆毳脞胆貂腚胨胴肚腭肪肥肺腓鼢服腹肤脯孚腑郛肝肛胳膈哿肱股臌胍盥胱虢胲貉贺貉毁肌加架驾迦胛袈毽腱脚胶胫腈肼舅臼雎脚爵胩胯脍腊肋肋力脸臁膦胧胪氇脶脉毛貌朦觅脒腼邈膜貉貊貘毪肭腩脑腻脲脓胖膀脬胚朋鹏膨脾貔胼脯氆脐肷腔且朐肜乳朊脎腮臊膳膻胂胜受鼠腧甩舜叟胎肽毯膛腾滕腆腿豚脱妥腽腕脘璺肟鼯膝奚鼷舄县腺胁勰腥胸貅须悬腌胭鼹遥腰鹞舀繇腋臆胰媵用臃有鼬繇舆腴臾舁爰月刖脏毡胀胗朕肢脂豸膣胝肿肘繇助肫腙胙"
    "埃霭埯坳霸坝耙坂雹孛埤贲甏贲埤博勃孛鹁埔埠才裁场超朝耖坼趁城埕赤翅坻墀矗寸戴埭地堤坻觌颠坫耋堞垤动垌都都堵堆墩垛二坊霏坟封赴垓干赶甘坩塥圪耕埂垢彀鼓毂瞽卦圭过埚韩翰顸邗邯耗郝壕赫盍堠壶觳坏卉恚魂霍耠吉圾霁戟赍嘉耩教截劫颉进境井赳趄均垲刊堪坎考壳坷坑堀垮块款圹亏逵坤垃老耢雷耒塄雳嫠坜墚趔埒霖零酃垅耧露垆卖埋霾墁耄霉耱某坶南赧垴霓坭埝耨耦耙耪培霈彭堋坯霹鼙圮埤坪坡埔起耆亓圻乾墙趄罄磬謦去趣趋却悫壤韧颥霰丧埽啬霎埏墒垧赦声十士示埘螫霜寺耜索塔塌坦坛坍趟塘耥韬填霆垌土堍坨顽未违韦圩雯斡无雾坞圬喜熹霞献霰孝霄协颉馨幸需墟圩雪埙垭盐堰懿埸圯壹垠霪圻堙墉雨域雩元远袁垣鼋塬垸越运云耘韫载哉栽趱增朝赵者赭真震圳直支志址埴煮翥专耔趑走"
    "瑷熬敖骜鳌遨獒聱螯鏊班斑逼碧表殡玢丙邴玻残蚕璨曹虿琛豉亍琮璁殂璀带歹殆玳殚到纛玷靛玎豆逗毒蠹顿趸恶噩垩珥珐玢夫副麸丐鬲亘更珙规瑰珩翮珩互瑚琥画环璜惠珲虺珲击殛丌玑夹颊珈郏歼戬戋豇晋瑾静靓救玖琚珏开珂琨来赉琅理丽璃吏郦逦鹂鬲殓琏两靓列烈裂琳玲琉珑璐珞玛麦迈劢瑁玫灭珉玟末殁囊瑙辇弄琶琵殍平珀璞妻琪琦琴青琼求球裘逑璩融瑞卅瑟珊殇事豕殊死素琐瑭忑替天忝殄餮吞屯橐瓦万玩豌琬王玮五武恶吾兀鹉下瑕现燹形型刑邢顼璇殉亚琊严焉琰鄢殃瑶珧一夷殪瑛璎于与玉瑜迂欤盂瑗殒再瓒遭责盏璋珍臻政正至致殖郅逐珠赘琢琢"
    "凹龅悲辈彪卜步卜睬餐粲柴觇龀瞠齿眵瞅龊此雌鹾眈瞪睇点盯鼎督睹盹非斐翡蜚壑虎乩睑睫睛旧韭具瞿遽龃矍卡瞰瞌肯龈眍眶睽睐瞵龄卢颅卤虏鸬虑瞒眯芈眠眄瞄眇瞑眸目睦睨虐盼裴睥瞟频颦攴歧虔瞧觑瞿龋氍睿上叔丨睡瞬兕瞍睢眭睃忐眺龆瞳凸凹龌瞎些虚盱眩睚眼眙龈卣虞龉眨砦战占瞻贞睁止瞩桌卓紫龇眦觜訾赀觜"
    "澳灞浜弊敝濞滗汴憋蹩鳖滨濒波泊渤不沧漕测涔汊潺澶常尝敞氅潮澈沉尘澄池滁淳淙淬沓淡澹当党凼滴涤淀滇洞渡渎沌沲洱法泛沸淝汾瀵沣浮涪滏尜溉泔澉淦港沟沽汩灌涫光滚海汉汗涵瀚沆浩灏濠河涸洪鸿泓黉鲎湖沪浒滹滑淮涣浣洹漶潢湟汇辉洄浍混浑溷活济激脊汲洎浃湫渐尖溅涧湔江洚觉浇湫洁津浸泾酒举沮涓觉浚渴溘喾浍溃涞濑滥澜漤浪潦涝泐泪漓沥溧澧涟濂潋梁粱潦劣洌淋泠流溜浏鎏泷漏泸漉潞渌滤滦沦洛泺漯满漫漭泖没湄浼懑泌汨湎沔渑渺淼泯溟漠沫沐淖泥溺涅泞浓沤派湃潘泮滂泡沛湓澎淠漂瞥婆泊泼泺浦瀑溥濮汽泣漆沏淇汔柒洽浅潜沁溱清泅湫渠雀染溶汝濡洳溽润洒挲涩沙挲鲨裟汕潸尚赏裳少潲涉滠深沈渗渖省渑湿淑漱澍沭涮泷水汜泗澌淞溲溯涑濉挲娑沓漯溻汰滩潭澹堂汤烫淌棠溏涛淘滔洮涕添汀潼涂湍沱洼湾汪渭潍洧沩涠温汶渥沃涡污浯鋈洗溪淅汐浠涎湘小消潇肖削逍淆泄泻瀣渫兴汹溴浒洫溆渲漩泫学削泶洵汛浔浚涯演沿淹湮滟洋漾泱耀液溢漪沂淫湮洇瀛滢潆涌泳游油誉浴渔渝淤源渊沅瀹澡泽渣沾湛掌涨漳沼浙浈溱治滞汁洲注洙渚潴浊濯涿浞滋渍滓淄"
    "暧暗昂蚌暴曝蚌蝙晡螬蝉蟾昌畅晁晨蛏匙螭虫蜍蝽旦戥电蝶蚪遏蛾蜂蜉蚨蝠蝮旰杲虼蚣蛊蛄归晷炅果蝈蜾蛤旱晗蚶昊蚝颢曷蚵虹蝴晃蝗蟥晦晖蛔蟪夥蠖虮蛱坚监鉴蛟蚧紧景晶炅颗蝌蚵旷暌蝰昆蛞蜡旯览螂里蜊蛎蠊量晾临蛉蝼螺蚂蟆曼螨蟒冒昴昧盟蠓蜢虻冕蠛明暝螟蛑蝻曩蛲昵暖蟠螃蟛蚍蜱螵蛴蜞蜣螓晴蜻蚯虬蝤蛐蛆蠼蜷蚺日蝾蠕蚋晒蟮晌蛸蛇申肾晟是时师匙暑竖墅曙帅蟀蛳螋遢昙螳螗题剔蜩蜓蜕暾蛙晚蜿旺韪蚊蜗晤蜈晰曦蟋蜥螅暇虾显贤暹蚬蟓晓蛸歇蝎昕星煦勖暄曛蚜蜒晏蛘曜野曳晔易蛇蚁蜴蚓影映蝇蛹蚰蝣蝤蚴遇愚禺昱蝓蜮螈曰晕昀早昃蚱蟑照昭蜘蛭蛛蛀最昨"
    "啊呵嗄吖唉哎嗳嗌嗷吧叭跋呗趵呗蹦嘣鄙哔吡跸别跛趵踣啵哺卟嚓踩嘈蹭噌喳嚓躔唱吵嘲嗔呈噌逞吃哧嗤叱踟踌躇蹰啜踹嘬川串喘吹啜踔呲蹴蹿啐蹉嗒哒呆呔啖蹈叨蹬噔嘀嗲踮吊叼跌喋踮蹀叮啶咚嘟吨蹲踱咄跺哆哚哦呃鄂颚鹗蹯啡吠吩唪咐趺跗呋咖嘎噶咯嗝跟哏哽咕呱剐咣贵跪呙哈嘿咳嗨喊号嚎嗥嚆喝吓呵嗬嘿嗨哼哄喉吼呼唬唿哗踝患唤喙哕咴嚯叽跻唧咭哜戢跽跏践趼踺叫嚼跤噍嗟喈噤啾距咀踽踞鹃嚼嗟蹶噱噘咖喀咔呵咳嗑啃吭口叩哭跨哙哐喟喹跬啦喇啷唠叻嘞哩喱呖唳跞踉嘹咧躐躏啉另呤咙喽路噜鹭吕呒吗骂嘛唛咪嘧黾喵咩黾鸣嘿哞嗯唔呢哪呐喃囔呶呢嗯唔呢蹑嗫啮咛哝喏哦噢喔呕趴啪哌蹒跑咆呸喷嘭啤噼吡蹁嘌品噗蹼器蹊嘁遣呛跄跷噙嗪吣嚷喏蹂嚅噻嗓啥嗄唼跚哨呻哂史嗜嘘噬唰顺吮嘶嗣咝嗽嗾嗖嗉虽嗦唆唢嗍踏嗒蹋趿呔跆叹啕饕踢啼蹄嚏跳听嗵吐唾跎鼍哇味唯喂吻嗡喔吴呜唔吸嘻蹊唏吓唬呷跣跹响嚣啸哮哓躞兄嗅咻吁嘘喧噱勋呀哑咽唁咬吆叶咽噎遗咦呓咿噫邑嗌吟喑吲嘤郢哟唷踊咏喁呦吁喻员跃郧咋咂咱躁噪唣咋啧咋喳哳吒咤啁只吱趾踯跖踬中忠踵盅咒啁嘱躅嘬啭啄吱呲踪足躜嘴咀嘬唑"
    "黯罢畀黪车畴黜辍辏町黩囤轭恩罚畈辅辐罘轧罡固轱罟轨辊国黑轰囫轷圜回辑畸羁墼甲囝较轿界轲困罱累罹詈轹连辆辚囹辘轳辂略轮囵罗逻皿默墨男囡囝嬲畔辔毗罴圃畦堑黔椠轻圊黥囚黢圈辁畎轫软轼输署蜀四思田畋町图团疃囤畹辋围畏胃囗軎辖黠轩鸭轧罨轺轶黟因黝囿圄圉园圆辕圜暂錾罾轧斩辗罩辙辄畛轸置轾轵轴转辎罪"
    "岸盎岜败贝崩髀贬豳髌财册岑崇帱遄幢赐崔嵯丹赕帱嶝迪骶典巅雕岽峒赌髑峨贩帆幡峰酆幅赋幞赙赅刚岗冈骼屹购岣骨鹘崮刿帼崞骸骺岵鹘幌贿岌觊嵴岬见贱峤骱巾赆迥崛峻凯剀髁岢崆骷髋贶岿崃岚崂嶙岭髅嵝赂幔帽峁嵋岷内帕赔帔岂崎岐屺髂嵌岍峭峤赇曲岖冉嵘肉山删赡赊嵊峙赎崧嵩岁髓炭贴帖同彤峒骰崴网罔巍帷帏崴嵬幄峡岘崤岫峋崖岈岩崦央鸯崾贻屹嶷峄婴罂鹦由邮幽屿峪嵛崽赃则帻贼赠崭帐账嶂幛赈峥帧帜峙帙周胄贮赚颛幢嵫赚"
    "懊悖鐾必避壁臂璧愎嬖襞忭檗擘怖惨惭孱恻层忏孱羼怅惝怊忱迟尺憧忡丑惆怵憷怆戳翠悴忖怛蛋惮导悼忉翟殿惦刁懂恫惰愕屙飞悱愤怫改敢怪惯憾悍憨恨恒惚怙怀慌惶恍悔恢己忌悸屐届尽惊憬局居剧惧屦慨恺忾慷尻恪快愧悝愦悃懒愣悝怜懔鹨戮履屡买慢忙眉鹛懵乜民悯愍那恼尼怩尿乜忸懦怄怕怦屁辟劈譬疋甓屏恰悭慊悄憔愀怯惬慊情屈悛慑慎尸屎恃虱收书属疏疋刷司巳悚忪愫惕屉悌恬恸恫屠臀惋惘慰尾惟尉屋悟毋忤怃习惜犀屣遐屑懈心忻性悻惺恤胥迅巽恂疋恹怏已异忆翼乙怡翌羿怿悒慵忧羽愉熨悦愠熨恽憎翟展怔咫忮忪昼惴怍"
    "庵鏖廒粑爆焙庇庳煸炳灿糙廛鬯炒焯炽床炊糍粗粹灯底店度断煅炖烦燔废粉粪烽府腐黼黻糕庚赓广庋炔焊焓烘糇糊烀煳焕煌麾烩火麂糨烬廑精粳炯炬爝麇康炕糠烤库邝廓烂廊烙类粒粝廉炼粮料廖燎麟遴粼廪熘娄炉鹿庐烙麻熳麽煤糜焖米迷靡糜麋敉縻庙麽磨摩魔粘糯庞炮庖庀粕麒炝廑庆糗炔麇燃熔糅糁煽剡熵烧麝糁炻数庶烁燧郯唐糖庭烃煺庹烷为炜煨庑焐席熄烯粞籼庠廨庥序糈炫煊烟炎焰焱剡烊炀业烨邺熠应鹰膺庸煜燠庾糌糟灶凿燥炸粘遮鹧黹烛炷麈庄灼焯籽粽座凿"
    "安案袄宝褓被褙裨窆褊裱宾补察衩禅衬宸裎褫宠初褚穿窗祠窜褡裆宕祷定窦裰额福富袱祓割袼宫寡褂官冠宄害寒罕鹤褐宏祜宦寰逭祸豁寄寂家袷蹇謇裥窖襟衿窘究裾窭军皲客窠裉空寇裤窟宽窥褴牢礼帘裢裣寥寮窿禄褛裸寐袂密蜜宓祢幂冥寞衲祢宁甯农襻袢袍裨祈祺祁袷骞搴褰襁窍窃寝穷穹祛裙禳衽容冗褥襦赛塞塞衫社神审实视室守祀宋宿邃它袒裼窕祧突褪褪袜完宛剜窝寤禧穸禊宪祆祥宵写袖宿宣穴窨宴窑窈宜寅窨宥宇寓裕窬窳冤郓灾宰宅窄寨这褶祯鸩之窒祉祗冢宙祝褚窀禚字宗祖祚"
    "锕锿铵犴钯鲅钣镑包鲍饱刨狈钡锛铋狴鳊镖镳鳔镔饼饽铂钵钹钸钚猜镲锸猹馇钗馋铲镡猖鲳钞铛铖饬鸱铳触雏锄刍舛钏锤匆猝镩错锉铛岛锝镫狄邸氐镝甸钿钓铫铞鲷鲽钉铤锭铥独镀锻镦钝镦多铎饿鳄锷锇儿尔迩饵铒鲕饭犯钒钫鲂鲱狒镄鲼锋负匐孵凫鲋鳆钆钙钢镐锆镉铬鲠觥够狗勾钩锢钴觚鲴馆鳏逛犷龟鲑鳜鲧锅猓铪镐狠訇猴忽狐斛猢鹱猾铧奂锾郇獾鲩鳇昏馄锪钬镬急饥鲫鲚钾镓铗键锏饯鲣角饺狡鲛铰解桀鲒金锦馑镜鲸獍久灸句锯钜锔狙镌锩狷獗镢觖钧铠锎锴钪铐钶锞铿狯狂馈鲲锟铼镧狼锒铹铑鳓镭狸鲤鳢鲡猁锂链镰鲢镣钌獠猎鳞铃鲮留遛馏镏锍镂鲁鲈镥铝卵锊锣猡镙犸馒鳗镘猫贸卯锚铆猸镅镁钔猛锰猕免勉名铭馍镆钼钠镎馕猱铙馁鲵猊铌鲶鲇鸟袅镊镍狞钮狃钕锘钯刨狍锫铍鲆钷钋铺匍镨镤鳍钱欠铅钳钎钤锵锖镪锹锲钦锓卿鲭鳅犰鸲劬铨然饶饪狨铷锐鳃馓鳋色铯煞铩钐鳝觞勺猞氏饰狮蚀鲥铈鲺狩铄饲锶馊锼稣觫狻狲飧锁鳎铊獭鲐钛镡锬钽铴镗饧逃鼗铽锑逖钿鲦铁铤铜钭兔钍饨鸵铊外危猥猬鲔刎我勿钨夕锡玺铣饩狭狎鲜馅猃锨铣象镶饷销枭蟹邂獬鑫锌镡猩饧匈锈馐铉镟鳕旬郇獯鲟钥铫鳐铘逸镒猗钇饴铱镱印银饮铟狺夤迎镛鳙犹鱿铀铕狱鱼馀狳饫钰怨猿鸳眢钥钺匀狁锗锃铡詹獐兆钊锗镇针争铮狰鲭钲炙觯钟锺皱猪铸铢橥馔锥镯锱鲻邹鲰镞钻鳟"
    "挨皑捱按氨揞拗翱把拔扒魃捌白摆拜掰捭搬扮拌扳报抱卑鹎摈兵摒播拨搏掰帛捕擦掺操插刹搽拆搀掺抄撤扯抻撑持斥魑抽搐揣搋氚捶攒撺摧措搓挫撮打搭担掸氮挡捣氘的提抵垫掂掉瓞揲氡抖兜盾遁掇扼摁反返氛扶抚拂氟拊擀扛搞皋搁搿拱挂瓜拐掴掼鬼皈掴氦撼捍撖皓后逅护换擐皇遑挥攉技挤掎挟皎挢敫捡拣搛搅皎敫挢接捷揭拮近斤揪据拒拘掬捐掘抉攫撅捃揩看抗扛拷氪控扣抠挎魁揆捆括扩拉拦揽捞擂魉撩撂捩拎拢搂掳撸捋氯掠抡摞捋抹魅扪描抿摸抹拇捺氖攮挠拟捻撵拈捏拧扭拗挪搦爬扒排拍拚乓抛捧抨批披郫擗撇氕拼拚乒迫魄皤掊扑气颀掐掮扦抢撬郄擒揿氢氰邱丘泉攘扰热扔揉撒搡扫搔杀刹擅掺掸捎摄势拾逝誓拭弑手授抒摅摔拴搠撕搜擞损所挞抬探摊搪掏提掭挑挺捅投抟推托拖拓挖挽皖魍握挝捂希郗欷掀氙魈携挟撷欣擤凶揎踅押揠氩掩扬氧摇邀肴爻拽揶掖抑揖刈挹殷氤撄拥揄援掾岳氲扎拶攒拶皂择扎揸摘搌找招折哲蛰摺蜇振挣拯指质执挚掷贽卮摭絷鸷拄抓爪拽撰撞捉拙擢揍攥撙撮"
    "桉柏板棒榜梆杯本标杓彬槟柄柏逋醭材槽查杈楂槎檫郴榇橙枨酲柽敕酬楚橱杵楮樗椽槌棰醇椿刺枞楱醋酢榱村档棣柢顶丁酊栋杜椟椴柁梵樊枋榧焚棼酚枫覆甫敷桴概杆橄柑酐杠槁槔歌格哥根梗构枸梏酤栝棺桄桂柜桧棍椁醢酣杭核横桁醐槲桦槐桓桧机极棘楫贾枷检槛柬枧楗校椒酵醮杰禁槿柩桕桔橘椐枸榉醵鄄橛桷楷槛栲可柯棵酷枯框醌栝剌赖栏榄婪榔酪醪栳檑酹楞棱李栗枥栎醴楝椋林檩棱棂柃柳榴栊楼麓栌橹榈椤杩懋梅枚酶楣梦檬醚棉杪酩模木柰楠酿柠杷攀配醅棚枇票飘瓢剽榀枰朴棋栖杞槭桤枪樯桥樵橇覃檎楸麴权醛榷桡榕枘梢森酾杉栅梢杓椹柿酾术树述束梳枢栓松速酥粟酸榫梭桫榻酞覃檀樘醣桃梯醍梃桶桐酮酴椭酡柁柝枉桅梧杌西析樨皙檄醯柙酰想相橡校枵械榭楔榍醒杏朽栩酗醑楦醺桠檐酽样杨要杳椰椅酏樱楹酉柚榆橼栎樾酝枣札栅榨柞楂栈杖樟棹柘枕甄桢椹榛整枝植栉枳桎栀酯酎柱株杼槠桩椎酌梓棕枞醉樽柞酢"
    "矮奥岙笆稗版般舨备惫笨笔币鼻彼篦秕舭筚箅笾秉簸舶箔簿舱艚策长徜彻掣称程称乘惩秤笞篪彳重艟愁筹臭稠处船舡垂辞囱簇徂篡汆矬答笪待箪稻得德等簦第敌笛籴簟迭牒丢冬篼笃牍段短簖躲舵鹅乏筏翻番繁彷舫篚逢缶复符阜稃馥竿秆缸筻告稿睾篙郜各舸躬篝笱箍鹄刮鸹乖管罐簋鼾行航和禾很衡後篌乎鹄笏徊徨簧篁徽徊秽和积籍季稽笈稷嵇箕笄稼笳徼简箭舰笺笕矫徼街秸筋径咎矩榘筠靠科稞箜筘筷筐篑籁徕篮稂乐利黎笠梨篱犁黧篥笼篓簏舻律稆乱箩雒么每艋艨秘秒篾敏鳘秣穆年黏臬牛衄筢牌徘盘磐彷逄篷片篇丿笸鄱乞迄憩千签迁愆箝乔箧箐筇秋鼽躯衢筌缺穰壬稔入箬穑歃筛舢稍筲艄射舌身矧生升剩甥笙眚失释适矢舐筮艏黍秫税私笥艘簌算穗笋躺甜舔条笤廷艇筒透徒秃颓乇箨往委微魏逶艉稳务午舞乌邬迕系息稀悉徙舾罅先衔舷筅向香箱笑箫筱卸衅囟行秀臭徐选血循熏徇衙延衍筵鼽秧徉夭徭移役迤舣劓胤牖釉禹御毓竽箢乐粤筠赞簪昝造迮笮箦舴怎乍齄长笊箴稹征徵筝知制智秩徵稚雉种重舯螽舟籀朱筑竹箸竺邾舳篆追自秭笫租纂笮"
    "癌疤半瓣瘢癍北背邶迸闭痹辩辨辫瘭瘪并病冰部瓿曾差差瘥产阐冁阊痴瘛冲瘳闯疮次差慈瓷兹疵鹚凑瘁痤瘥瘩疸单瘅疸郸道盗弟递羝奠癫癜凋疔冻斗痘端兑阏阀痱疯冯盖赣疳戆羔阁疙羹痼关闺衮馘阚阂阖痕闳瘊冱痪豢癀阍疾冀瘠痂瘕间减兼剪煎翦鹣将奖酱姜浆桨交郊竭疖疥羯竟竞净靖痉疚阄疽卷眷桊蠲决竣阚闶疴况夔阃阔辣瘌癞兰阑阆痨冷立痢疠疬凉疗冽凛凌羚六瘤癃瘘闾瘰美门闷闽闵瘼闹逆凝疟判叛爿疱疲痞癖瓶剖普凄前歉羌戕羟妾亲酋遒癯阒券拳痊瘸阕阙闰飒瘙痧善闪鄯疝韶首瘦兽闩朔槊送凇竦塑遂羧闼瘫痰羰疼誊剃鹈阗痛童头痿闱问闻瘟阌痦羲阋瘕闲羡鹇痫冼翔鲞效新辛歆羞券痃癣丫痖颜阎阉彦闫阏兖养羊痒恙疡冶意益毅疫痍瘗癔翊音瘾瘿痈猷疣阈瘐瘀阅韵奘甑闸痄瘵站章彰瘴鄣着着疹郑症痔痣瘃疰装状壮妆奘戆准着资咨姿兹恣孳粢总尊遵"
    "嫒媪婢妣婊剥姹婵娼嫦巢媸巛妲逮刀嫡娣妒娥婀发妨妃妇旮艮媾姑妫好婚即既姬嫉妓暨嫁建奸娇姣剿姐婕妗婧九鸠娟君郡恳垦馗邋姥嫘隶娌灵录逯妈嬷妹媒媚娩妙嫫姆娜奶嫩妮娘妞怒努奴弩驽胬孥女媲嫖姘嫔娉嫱群娆忍刃妊如嫂姗嬗邵劭婶娠始恕姝孀妁姒肃她帑迢婷退娃娲婉丸娓妩媳嬉嫌娴姓絮旭婿寻巡娅妍嫣姚妖姨姻尹邕娱妪妤聿媛杂甾嫜召帚妯姊"
    "俺傲八爸伯佰伴颁傍保堡煲倍坌俾便飚飑傧伯仓伧侧岔侪偿倡倘伥伧侈傺仇雠俦储传创从丛促催隹代袋贷黛岱傣但儋倒登凳低佃爹佚仃侗朵剁俄佴伐垡凡仿分份忿偾风凤俸佛父付佛伏傅俯斧俘釜伽个鸽颌仡公供佝谷估倌刽傀癸含颔何合盒颌候侯华化凰会货伙几集祭伎偈佶价假佳佼侥伽件健剑俭僭牮僵焦佼侥僬鹪介借偈今仅儆僦俱飓倨倦隽倔俊隽佧侃龛伉倥侉会侩郐傀佬仂儡例俐俚俪傈俩敛俩僚邻赁领令伶翎瓴偻侣伦仑倮们命侔仫拿佴恁你倪伲念您恁佞侬傩偶俳佩盆僻仳便偏贫凭俜仆企俟伽倩佥仟戗侨俏劁伽侵禽衾倾俅全人任仁仞仍儒偌仨伞僧傻伤舍佘畲歙什伸使食侍仕售舒俞倏毹殳似伺俟耸颂怂飕俗夙僳隼他贪倘傥体倜佻停佟侗仝偷途氽佗佤位伟伪偎翁瓮倭伍侮仵兮翕僖歙侠仙像斜偕信修休鸺叙儇伢俨偃仰佯侥爷依亿伊仪倚佚仡佾佣俑优悠佑攸侑余欲愈逾俞觎伛俣鹆龠仔债仗仉侦值侄众仲住伫侏传僮隹倬仔偬俎作做坐佐"
    "绊绑鸨绷比毕毙匕弼毖编缏缤缠绰弛绸绌纯绰绐弹缔绨缎缍纺费绯纷缝弗缚艴绂绋绀纲缟纥给绠弓缑贯纶绲绗纥红弘弧缓幻缳绘缋给级纪继绩缉畿缄缣强疆犟缰绛缴绞结皆缙经弪纠绢绝缂绔纩缆缧蠡缡练缭绫绺绿缕纶络缦弥弭糸缅绵缪缈缗缪缪母纳纽纰缏缥绮纤缱缲顷绻强绕纫绒缛弱缲缫纱缮绱绍绅绳绶纾丝鸶缌绥缩弹绦缇绨统彖纨绾维纬纹细线弦纤乡飨缃绡缬绁绣续绪绚幺疑绎彝缢肄引颖缨颍幼粥鬻纡缘约纭缲缯绽张缜织纸旨彘终粥纣绉缀缒缁纵综组缵"
    "哀谙谤褒变遍扁卞斌禀亳诧颤谄谗昶谶谌诚啻充畜鹑词卒诞谠帝诋谛丶调谍订读憝敦讹谔诶方放房访邡诽扉讽讣该高膏诰诟雇诂诖诡郭裹亥颃毫豪诃劾亨讧户戽扈话谎肓讳诲诙诨记计迹剂讥诘齑肩谏谫讲诫诘讦谨京旌扃就鹫讵诀谲亢刻课颏诓诳斓谰朗郎羸诔离戾恋良亮谅吝刘旒旅率膂峦挛孪栾銮娈鸾脔论蠃蛮谩盲氓邙袤旄谜谧谬谟谋亩讷旎诺讴旁旆烹翩扁谝评裒谱齐旗弃启讫綮谦谴敲诮谯请綮诎诠让瓤认扇讪商设谁诜谂市识诗试施谥熟孰塾率衰谁说诵讼诉谡谇谈谭讨调亭弯望忘亡妄谓诿文紊於误诬享详襄谢谐亵燮许畜诩旋玄谖谑询训讯讶言谚谳谣夜谒义议衣译亦谊裔弈奕诣旖诒赢嬴永雍壅饔诱语育於谕谀谮诈斋谵旃肇诏谪诊证诤衷州诌主诸诛谆诼谘诹族卒诅"
    "")
  "ASCII char to simplifed Chinese characters.")

(defconst pinyinlib--traditional-char-table
  '("艾藹鞍芭靶茇菝蒡薄苞葆蓓鞴萆苯蔽萆薜蓖荸芘蓽鞭苄匾薄菠菜蔡蠶藏蒼草茶茬蠆蕆菖萇臣茌茺蓴茲茨茈蔥蓯蔟萃韃靼帶甙萏蕩菪蒂荻董蔸芏躉苊萼莪蒽貳藩蕃蘩芳菲匪芾芬葑芙芾苻茯莩菔蓋苷藁革戈葛茛工共功攻貢恭鞏汞苟覯遘菇菰觀莞鸛匭菡巷蒿薅荷菏蘅薨蕻葒葫華花歡萑黃荒匯薈茴蕙葷或惑劐藿藉薊薺蒺芨蕺芰茄莢葭堅監艱薦繭菅韉蒹戔蔣匠茳蕉艽茭戒藉芥緊靳覲堇藎警驚敬荊莖菁舊巨菊鞠苴鞫苣莒蕨菌蒈莰苛恐蔻芤苦蒯匡葵匱蕢萊蘭藍覽莨蒗勒蕾莉蒞藜荔藶蘚蘺蓮蘞莨蓼臨藺菱苓蘢蔞蘆蓼落蘿邁勱蕒蔓顢鞔茫芒莽茅茂茆莓夢蒙萌瞢甍蘼苗藐鶓蔑苠茗莫驀蘑茉摹幕慕墓募暮苜艿萘難匿慝廿蔫蔦孽苧歐毆鷗甌藕葩蒎蓬匹芘莩苤萍蘋叵葡蒲菩莆七萋芪薺芑萁蘄葺葜芊蕁芡薔巧鞘蕎鞽切茄勤芹芩擎檠邛蛩跫銎區蕖蘧苣勸顴荃鵲苒蕘惹葚荏蓉戎茸鞣茹薷蓐芮蕤蕊若薩散莎芟苫鞝苕鞘芍腎莘葚世式蓍蒔貰薯豎蔬戍菽蒴菘藪蘇蔌蒜荽蓀蓑苔薹萄鞀忒慝忒藤荑苕萜莛葶茼荼菟忒萬莞芄菀蔚萎葦薇葳蓊蕹臥萵巫蕪芴昔熙茜覡菥葸蓰匣賢薟蘚莧項巷葙薌蕭鞋邪薤薪芯荇芎蓄蓿萱靴薛薰葷荀薰蕈雅牙鴉芽迓燕鹽芫郾菸鞅藥葉醫藝艾頤弋薏荑苡翳茵蔭鄞茚英莠莜蕕萸芋菀蕷苑芫鳶蘊芸匝藏葬臧藻賾盞蘸蔗蓁蒸芝芷葤著茱苧莊茁茲茈菹蕞"
    "阿隘阪阪孢陂陛陳承丞恥蚩出除陲聰耽聃阽耵陡隊墮耳防附尕陔戤隔耿孤聒孩函隍隳及際亟降階孑巹阱聚孓孔聵隗了聯了聊陵聆陸隆隴陋陸孟勐陌乃鼐聶隉顳櫱聹皰陪皮陂陴聘頗陂亟阡取娶孺阮陝聖隨祟隧隋孫陶糶聽陀隈隗阢隙隰險限陷降陘遜阽陽也耶隱陰盈隅院孕隕障陣職陟騭墜子孜陬鄹阻阼"
    "巴畚弁驃駁參驂參叉驏騁馳驄皴怠迨駘犢馱駙牿牯駭驊驥犄犍驕矜駒犋駿犒騍驪騮驢駱騾馬矛蟊蝥瞀鍪牧牟牡能騙犏駢驃牝騎騏犍驅逡柔叄毿桑顙騷騸參牲駛駟厶態邰駘炱特通駝馱物務鶩騖牾婺犧驤驍熊馴驗以矣驛勇恿甬又預予豫馭鷸允駔蚤驟駐騅騶"
    "礙砹鵪百邦磅碑碚奔夯甭泵砭碥飆髟鬢礴布礤碴長硨辰磣成盛舂礎春脣蠢磁蹙存磋厝大耷碭磴砥碲碘碉碟碇硐碓礅砘奪厄而鴯砝奮奉碸否砩尬感尷矸硌故古辜鴣嘏硅磙夯厚胡鶘瓠砉鬟磺灰慧彗基奇磯髻剞夾頰戛嘏郟恝礓礁碣兢鬏厥劂砍勘戡克磕刳礦夼盔奎髡砬磊歷勵厲礪礫奩遼鷯尥鬣磷碌硫碌硌碼硭髦礞面靦奈耐孬硇碾齧恧磅匏碰砰硼否丕砒邳破其期奇欺戚契砌欹綦磧鬈磽砌挈秦戌磲犬鬈確髯辱三磉砂髟奢厙甚蜃砷盛石耍爽碩斯肆鬆碎太泰碳套髫砼砣歪碗尢威硪戊矽硒夏硤硝硎雄髹戌砉碹壓砑研厭雁奄硯贗饜魘厴頁靨欹硬友右尤憂尢原願砸在仄砟長丈磔斟砧碡磚斫髭鬃奏左"
    "愛胺膀胞豹膘臏脖膊彩豺腸塍膪辭腠爨脆毳脞膽貂腚腖胴肚兒肪肥肺腓鼢服腹脯孚腑郛肝肛胳膈哿肱股臌胍盥胱虢胲貉賀貉黌鱟毀雞肌加架駕迦胛袈毽腱覺腳膠脛腈肼舅臼舉雎覺腳爵胩懇墾嚳胯膾臘肋肋力臉臁膦朧臚氌亂腡脈毛貓貌朦覓脒邈膜貉貊貘毪肭腩腦膩脲膿胖膀脬胚朋鵬膨脾貔胼脯氆臍肷腔且朐肜乳朊脎腮臊膳胂勝受鼠腧甩舜叟胎肽毯膛騰謄滕腆腿豚脫妥膃腕脘爲璺肟鼯膝奚鼷舄腺脅勰釁興腥胸貅須學澩胭鼴腰鷂舀繇腋臆胰媵用臃有鼬繇與譽輿腴臾歟舁爰月刖脹胗朕爭肢脂豸膣胝腫肘繇助肫腙胙"
    "埃靄垵坳霸壩耙幫報雹孛埤賁甏賁埤博勃孛鵓埔埠才裁場超朝耖坼趁城埕赤翅坻墀矗寸達戴埭地堤坻覿電顛墊坫耋堞垤垌都都堵堆墩垛二坊霏墳封赴垓幹趕甘坩塥圪耕埂垢彀鼓轂瞽卦圭堝韓翰頇邗邯耗郝壕赫盍堠壺觳壞卉恚魂霍耠吉圾霽戟嘉耩教截劫頡境井赳趄均塏刊堪坎考殼坷坑堀垮塊款壙逵坤垃老耮雷耒塄釐靂嫠壢墚趔埒霖靈零酃壠耬露壚賣埋霾墁耄氂耱某坶南赧堖霓坭埝耨耦耙耪培霈彭堋坯霹鼙圮埤坪坡埔起耆亓圻乾翹趄罄磬謦去趣趨愨壤熱顬霰喪埽嗇霎埏墒垧赦聲十士示勢塒螫壽霜寺耜索塔塌臺坦壇坍趟塘耥燾填霆垌土堍坨頑未圩雯斡霧塢圬喜熹霞霰孝霄協頡馨幸需墟圩雪塤埡堰堯懿埸圯壹垠霪圻堙墉雨域雩元遠袁垣黿塬垸越雲耘載哉栽趲增朝趙者蟄赭真震圳直支志執址摯贄埴縶鷙煮翥耔趑走"
    "璦熬敖驁鰲遨獒聱螯鏊班斑逼碧表殯玢丙邴玻殘璨曹琛豉亍琮璁殂璀歹殆玳殫到纛玷靛玎丟豆逗毒蠹頓惡噩堊爾邇珥琺玢夫副丐鬲亙更頸珙規瑰珩翮珩互瑚琥環璜惠琿虺琿殛丌璣珈殲戩豇勁晉瑾靜頸逕剄靚救玖琚珏珂琨琅理麗璃吏酈邐鸝鬲殮璉兩靚列烈裂琳玲琉瓏璐珞瑪瑁玫珉玟末歿囊瑙輦弄琶琵殍平珀璞妻琪琦琴青瓊求球裘逑巰璩融瑞卅瑟珊殤事豕殊死素瑣瑭忑替天忝殄餮頭吞屯橐瓦玩豌琬王瑋五武惡吾兀鵡璽下瑕現燹形型刑邢頊璇殉亞琊焉琰鄢殃瑤珧一夷殪瑛瓔玉瑜迂盂瑗殞再瓚遭責璋珍臻政正至致殖郅逐珠豬櫫專贅琢琢"
    "凹齙悲輩彪卜步卜睬餐粲柴覘齔瞠齒眵瞅處齪此雌鹺眈瞪睇盯鼎鬥督睹盹齶非斐翡蜚膚劌壑虎乩見鹼鹼瞼睫睛韭鬮具劇瞿遽齟矍卡瞰瞌肯齦瞘眶虧睽睞瞵齡盧顱虜鸕慮瞞眯羋眠眄瞄眇瞑眸目睦鬧睨虐盼裴睥瞟頻顰攴歧虔瞧覷瞿齲氍睿上叔丨睡瞬兕瞍歲睢眭睃忐眺齠瞳凸凹齷戲鬩瞎縣獻鹹些虛盱懸眩睚眼眙齦卣虞齬眨砦瞻貞睜止矚桌卓紫齜眥觜訾貲觜"
    "澳灞浜幣弊斃敝濞潷汴憋蹩鱉濱瀕波泊渤不滄漕測涔汊潺澶常嘗敞氅潮澈沉澄池滁淳淙湊淬沓淡澹當黨凼盜滴滌澱滇洞渡瀆沌沲洱法泛沸淝汾瀵灃浮涪滏尜溉泔澉淦港溝沽汩灌涫光滾海漢汗涵瀚沆浩灝濠河涸洪鴻泓湖滬滸滹滑淮渙浣洹漶潢湟輝洄澮混渾溷活濟激脊汲洎浹湫減漸尖濺澗湔江洚澆湫潔津浸淨涇酒沮涓決浚渴溘澮況潰淶瀨濫瀾灠浪潦澇泐淚漓瀝溧澧漣濂瀲涼粱潦劣洌淋泠流溜瀏鎏瀧漏滷瀘漉潞淥濾灤淪洛濼漯滿漫漭泖沒湄浼懣泌汨湎沔澠渺淼滅泯溟漠沫沐淖泥溺涅濘濃漚派湃潘泮滂泡沛湓澎淠漂瞥婆泊潑濼浦瀑溥濮汽泣漆沏淇汔柒洽淺潛沁溱清泅湫渠雀染溶汝濡洳溽潤灑挲澀沙挲鯊裟汕潸尚賞裳少潲涉灄深沈滲瀋省澠溼淑漱澍沭涮瀧水汜泗澌淞溲溯涑濉挲娑沓漯溻汰灘潭澹堂湯燙淌棠溏濤淘滔洮涕添汀潼塗湍沱灣汪渭濰洧潙潿溫汶渥沃渦污浯鋈洗溪淅汐浠涎湘小消瀟肖削逍淆泄瀉瀣渫洶溴滸洫漵渲漩泫削洵汛潯浚涯演沿淹湮灩洋漾泱耀液溢漪沂淫湮洇瀛瀅瀠涌泳油浴漁渝淤源淵沅瀹澡澤渣沾湛掌漲漳沼浙湞溱治滯汁洲注洙渚瀦準濁濯涿浞滋漬滓淄"
    "曖暗昂蚌暴曝蚌畢蝙晡螬蟬蟾昌暢晁晨蟶匙螭蟲蜍蝽旦戥蝶蚪遏蛾蜂蜉蚨蝠蝮旰杲虼蚣蠱蛄晷炅果蟈蜾蛤旱晗蚶昊蠔顥曷蚵虹蝴晃蝗蟥晦暉蛔蟪夥夥蠖蟣蛺蛟蚧景晶炅顆蝌蚵曠暌蝰昆蛞蠟旯螂蜊蠣蠊量晾蛉螻螺螞蟆曼蟎蟒冒昴昧盟蠓蜢虻冕蠛明暝螟蛑蝻曩蟯昵暖蟠螃蟛蚍蜱螵蠐蜞蜣螓晴蜻蚯虯蝤蛐蛆蠼蜷蚺日蠑蠕蚋曬蟮晌蛸蛇申晟是時匙暑墅曙蟀螄螋遢曇螳螗題剔蜩蜓蛻暾蛙晚蜿旺蝟韙蚊蝸晤蜈晰曦蟋蜥螅暇蝦顯暹蜆蟓曉蛸歇蠍昕星煦勖暄曛蚜蜒晏蛘曜野曳曄易蛇蟻蜴蚓影映蠅蛹蚰蝣蝤蚴遇愚禺昱蝓蜮螈曰暈昀早昃蚱蟑照昭蜘蛭蛛蛀最昨"
    "啊呵嗄吖唉哎噯嗌嗷吧叭跋唄趵唄蹦嘣鄙嗶吡蹕別跛趵踣啵哺卟嚓踩嘈蹭噌喳嚓囅躔唱吵嘲嗔呈噌逞吃哧嗤叱踟躊躇躕啜踹嘬川串喘吹啜踔呲蹴躥啐蹉嗒噠呆呔單啖鄲蹈叨蹬噔嘀嗲踮吊叼跌喋踮蹀叮啶咚嘟噸蹲踱咄跺哆哚哦呃鄂顎鶚蹯啡吠吩唪咐趺跗呋咖嘎噶咯嗝跟哏哽咕呱咣貴跪哈嘿咳嗨喊號嚎嗥嚆喝嚇呵嗬嘿嗨哼哄喉吼呼唬唿踝患喚喙噦咴嚯跡嘰躋唧咭嚌戢跽跏踐趼踺叫嚼跤噍嗟喈噤啾距咀踽踞鵑嚼嗟蹶噱噘咖喀咔呵咳嗑啃吭口叩哭跨噲哐喟喹跬啦喇啷嘮叻嘞哩喱嚦唳躒踉嘹咧躐躪啉另呤嚨嘍路嚕鷺呂嘸嗎嘛嘜咪嘧喵咩鳴嘿哞嗯唔呢哪吶喃囔呶呢嗯唔呢躡囁嚀噥喏哦噢喔嘔趴啪哌蹣跑咆呸噴嘭啤噼吡蹁嘌品噗蹼器蹊嘁遣嗆蹌蹺噙嗪唚嚷喏蹂嚅噻嗓啥嗄唼跚哨呻哂史嗜噓噬獸唰順吮嘶嗣噝嗽嗾嗖嗉雖嗦唆嗩嗍踏嗒蹋趿呔跆嘆啕饕踢啼蹄嚏跳嗵吐唾跎鼉哇味唯喂吻嗡喔吳嗚唔吸嘻蹊唏嚇唬呷跣躚囂嘯哮嘵躞兄嗅咻噓喧噱呀啞嚴咽唁咬吆咽噎遺咦囈咿噫邑嗌吟喑吲嚶郢喲唷踊喁呦喻員躍鄖咋咂咱躁噪唣咋嘖咋喳哳吒吒戰啁只吱趾躑跖躓中忠踵盅咒啁囑躅嘬囀啄吱呲蹤足躦嘴咀嘬唑"
    "黯罷畀黲車疇黜輟輳點疊町黷囤軛恩罰畈輔輻罘軋罡固軲罟軌輥國還黑轟囫軤還圜回輯擊畸羈墼甲囝較轎界軻困罱累壘罹詈轢連輛轔囹婁轆轤輅略輪圇羅邏罵買皿默墨男囡囝嬲畔毗羆圃畦塹黔槧輕圊黥囚黢圈輇畎軔軟軾數輸署蜀四思田畋町圖團疃囤畹輞圍畏胃囗軎轄黠軒鴨軋罨軺異軼黟因黝囿圄圉園圓轅圜暫鏨罾軋斬輾罩轍輒畛軫置輊軹軸轉輜罪"
    "岸骯盎岜敗貝崩髀貶豳髕財冊岑崇幬遄幢賜崔嵯丹賧幬嶝迪骶典巔雕崬峒賭髑峨販帆幡豐峯酆幅賦賻賅剛崗岡骼屹購岣骨鶻崮剮過幗咼崞骸骺岵鶻幌賄岌覬嵴岬賤嶠骱巾贐迥崛峻凱剴髁岢崆骷髖貺巋崍嵐嶗嶙嶺髏嶁賂幔帽峁嵋岷內農帕賠帔豈崎岐屺髂嵌岍峭嶠賕曲嶇冉嶸肉山刪贍賒嵊峙贖崧嵩髓炭體貼帖同彤峒骰崴罔巍帷幃崴嵬幄峽峴崤岫峋崖岈巖豔崦央鴦崾貽屹嶷嶧嬰罌鸚由幽嶼峪嵛嶽崽髒贓則幘賊贈嶄帳賬嶂幛賑崢幀幟峙帙周胄貯賺顓幢嵫賺"
    "懊悖鐾必避壁臂璧愎嬖襞忭檗擘怖慘慚孱惻層懺孱羼悵惝怊忱遲尺憧忡惆怵憷愴戳翠悴忖怛蛋憚悼忉翟殿惦刁懂恫惰愕屙飛悱憤怫改敢韝怪慣憾悍憨恨恆惚怙懷慌惶恍悔恢己忌悸屐屆憬局居懼屨慨愷愾慷尻恪快愧悝憒悃懶愣慄悝憐懍鷚戮履屢慢忙眉鶥懵乜民憫愍那惱尼怩尿乜忸懦慪怕怦屁劈譬疋甓屏悽恰慳慊悄憔愀怯愜慊情屈悛韌懾慎屍屎恃蝨收屬疏疋刷司巳悚忪愫韜惕屜悌恬慟恫屠臀惋惘慰尾違韋惟尉屋悟毋忤憮習惜犀屣遐屑懈心忻性悻惺恤胥選迅巽恂疋懨怏已憶翼乙怡翌羿懌悒慵羽愉熨悅慍熨惲韞憎翟展怔咫忮忪惴怍"
    "庵鏖廒粑爆焙庇庳煸炳燦糙廁廛廠鬯炒焯塵熾廚炊叢粗粹燈底店度煅對懟燉煩燔廢粉糞烽府腐黼黻糕庚賡廣庋炔焊焓烘糊烀煳煥煌麾燴火麂糨燼廑精粳炯廄炬爝麇康炕糠烤庫鄺廓爛廊勞烙類粒糲廉煉糧料廖燎鄰麟遴粼廩熘爐鹿廬烙犖麻熳麼麼煤糜燜米迷靡糜麋敉縻廟麼磨摩魔粘糯龐炮庖庀粕麒熗廑慶檾煢糗炔麇燃榮熔糅糝廈煽剡熵燒麝糝炻庶爍廝燧郯唐糖庭廳烴煺庹烷煒煨廡焐席熄烯粞廈廂庠廨滎庥序糈炫煊煙炎焰焱剡烊煬業燁鄴熠應營鷹瑩熒膺螢縈鶯塋滎鎣庸煜燠庾糌糟鑿燥炸粘遮鷓黹燭炷麈灼焯籽糉座鑿"
    "安案襖寶褓被褙裨窆褊裱賓補察衩禪襯宸裎褫寵初褚穿窗祠竄褡襠宕禱定竇裰額福富袱襆祓割袼宮寡褂官冠宄害寒罕鶴褐宏祜宦寰逭禍豁寄寂家袷蹇謇襇窖襟衿窘究裾窶軍皸客窠裉空寇褲窟寬窺襤牢禮褳襝寥寮窿祿褸裸寐袂密祕蜜宓禰冪冥寞衲禰寧甯襻袢袍裨祈祺祁袷騫搴褰襁竅竊寢窮穹祛裙禳衽容冗褥襦賽塞塞衫社神審實視室守祀宋宿邃它袒裼窕祧突褪褪襪窪完宛剜窩寤禧穸禊憲祆祥宵寫袖宿宣穴窨宴窯窈宜寅窨宥宇寓裕窬窳冤運鄆宰竈宅窄寨褶禎鴆之窒祉祗冢宙祝褚窀禚字宗祖祚"
    "錒鎄銨犴鈀鮁鈑鎊包鮑刨狽鋇錛鉍狴鯿鏢鑣鰾鑌鉑鉢鈸鈽鈈猜鑔鍤猹釵鏟鐔猖鯧鈔鐺鋮鴟銃觸雛鋤芻舛釧錘匆猝鑹錯銼鐺島鍀鐙狄邸氐鏑甸鈿釣銚銱鯛鰈釘鋌錠銩獨鍍鍛鐓鈍鐓多鐸鱷鍔鋨鉺鮞犯釩鈁魴鯡狒鐨鱝鋒負匐孵鳧鮒鰒釓鈣鋼鎬鋯鎘鉻鯁觥夠狗勾鉤錮鈷觚鯝鰥逛獷鮭鱖鯀鍋猓鉿鎬狠訇猴忽狐斛猢鸌猾鏵奐鍰郇獾鯇鰉昏獲鍃鈥鑊急鯽鱭鉀鎵鋏鍵鑑鐧鰹角狡鮫鉸解桀鮚金錦鏡鯨獍久灸句鋸鉅鋦狙鐫錈狷獗钁觖鈞鎧鐦鍇鈧銬鈳錁鏗獪狂鯤錕錸鑭狼鋃鐒銠鰳鐳狸鯉鱧鱺猁鋰鏈鐮鰱鐐釕獠獵鱗鈴鯪留劉遛鎦鋶鏤錄魯鱸鑥鋁卵鋝鑼玀鏍獁鰻鏝貿卯錨鉚猸鎇鎂鍆猛錳獼免勉名銘鏌鉬鈉鎿猱鐃鯢猊鈮鯰鯰鳥鑷鎳獰鈕狃釹鍩鈀刨狍錇鈹鮃鉕釙鋪匍鐠鏷鰭錢欠鉛鉗釺鈐鏘錆鏹鍬鍥欽鋟卿鯖鰍犰鴝劬銓然狨銣銳鰓鰠色銫煞鎩釤鱔觴勺猞氏獅鰣鈰鯴狩鑠鍶鎪穌觫狻猻飧鎖鰨鉈獺鮐鈦鐔錟鉭鐋鏜逃鋱銻逖鈿鰷鐵鋌銅鈄兔釷鴕鉈外危猥鮪刎我烏勿鎢鄔夕錫銑狹狎鮮獫銑象鑲銷梟蟹邂獬鑫鋅鐔猩匈鏽鉉鏇鱈旬郇獯鱘遙鑰銚鰩鋣逸鎰猗釔銥鐿印銀銦狺夤迎鏞鱅猶魷鈾銪獄魚狳鈺怨猿鴛眢鑰鉞勻狁鍺鋥鍘詹獐兆釗鍺鎮針錚猙鯖鉦炙觶鍾鍾皺鑄銖錐鐲錙鯔鄒鯫鏃鑽鱒"
    "挨皚捱按氨揞拗翱把拔扒魃捌白擺拜掰捭搬扮拌扳抱卑鵯擯兵摒播撥搏掰帛捕擦採摻操插剎搽拆攙摻抄撤扯抻撐持斥魑抽搐揣搋氚捶攢攛摧措搓挫撮打搭擔撣氮擋搗氘的提抵遞掂掉瓞揲氡抖兜盾遁掇扼摁反返氛扶撫拂氟拊擀扛搞皋擱搿拱掛瓜拐摑摜鬼皈摑氦撼捍撖皓逅換擐皇遑揮攉技擠掎挾皎撟敫撿揀搛攪皎敫撟接捷揭拮近斤揪據拒拘掬捐掘抉攫撅捃揩看抗扛拷氪控扣摳挎魁揆捆括擴拉攔攬撈樂擂魎撩撂捩拎攏摟擄擼捋氯掠掄摞捋抹魅捫描抿摸抹拇捺氖攮撓擬捻攆拈捏擰扭拗挪搦爬扒排拍拚乓拋捧抨批披郫擗撇氕拼拚乒迫魄皤掊撲氣頎掐掮扦搶撬郄擒撳氫氰邱丘泉攘擾扔揉撒搡掃搔殺剎擅摻撣捎攝拾逝誓拭弒手授抒攄摔拴搠撕搜擻損所撻擡探攤搪掏提掭挑挺捅投摶推拖拓挖挽皖魍握撾捂希郗欷掀氙魈攜挾擷欣擤兇揎踅押揠氬掩揚氧搖邀爻拽揶掖抑揖刈挹殷氤攖擁揄援掾樂氳扎拶攢拶皁擇扎揸摘搌找招折哲摺蜇振掙拯指質擲卮摭拄抓爪拽撰撞捉拙擢揍攥撙撮"
    "醃桉柏板棒榜梆杯本標杓彬檳柄柏逋醭材槽查杈楂槎檫郴櫬橙棖酲檉敕醜酬楚櫥杵楮樗椽槌棰醇椿刺樅楱醋酢榱村檔棣柢頂丁酊東棟鶇杜櫝椴柁梵樊礬枋榧焚棼酚楓覆甫敷桴麩概杆橄柑酐槓槁槔歌格哥根梗構枸梏酤栝棺桄桂櫃檜棍槨醢酣杭核橫桁醐槲樺槐桓檜機極棘楫賈枷檢檻柬梘楗校椒酵醮禁槿柩桕桔橘椐枸櫸醵鄄橛桷楷檻栲可柯棵酷枯框醌栝剌來賴賚欄欖婪榔酪醪栳檑酹楞棱李隸櫪櫟醴楝樑椋林檁棱欞柃柳榴櫳樓麓櫨櫓櫚欏榪麥懋梅枚酶楣檬醚棉杪酩模木柰楠釀檸杷攀配醅棚枇票飄瓢剽榀枰樸棋棲杞槭榿遷槍檣橋樵橇覃檎楸麴權醛榷橈榕枘梢森釃杉柵梢杓椹柿釃樹述束梳樞栓速酥粟酸榫梭桫榻酞覃檀樘醣桃梯醍梃桶桐酮酴橢酡柁柝枉桅梧杌西析樨皙檄醯柙杴醯想相橡校枵械榭楔榍醒杏朽栩酗醑楦醺椏檐醃釅樣楊要杳椰椅酏櫻楹酉柚鬱榆櫞櫟樾醞棗札柵榨柞楂棧杖樟棹柘枕甄楨椹榛整枝植櫛枳桎梔酯酎柱株杼櫧樁椎酌梓棕樅醉樽柞酢"
    "矮奧嶴笆稗版般舨笨筆鼻彼篦秕舭篳箅邊籩秉簸舶箔簿艙艚策徜徹掣稱程稱乘懲秤笞篪彳重衝艟愁籌臭稠船舡垂從囪簇徂篡汆矬答笪待簞稻得德等簦第笛糴簟迭牒動冬篼篤牘段短籪躲舵鵝乏筏翻範番繁彷舫篚逢缶復符阜稃馥竿稈缸筻告稿睾篙郜各舸躬篝笱箍鵠刮鴰乖管罐歸龜簋鼾行航和禾很衡後後篌乎戶鵠笏徊徨簧篁徽徊穢和積籍季稽笈稷嵇箕笄稼笳徼簡箭艦箋筧矯徼節街秸筋徑咎矩榘筠靠科稞箜筘筷筐簣籟徠籃稂利黎笠梨籬犁黧篥簾籠簍簏艫律穭籮雒每黴艋艨秒篾敏鰵秣穆年黏臬牛衄筢牌徘盤磐彷逄篷片篇丿笸鄱乞迄憩千籤愆箝喬篋箐筇秋鼽軀衢筌缺穰壬稔入箬穡歃篩舢稍筲艄射舌身矧生升剩甥笙眚師失釋矢舐筮艏術黍秫帥稅私笥聳慫艘簌算穗筍躺甜舔笤廷艇筒透徒禿頹乇籜往委衛微魏逶艉穩無午舞迕系息稀悉徙舾罅先銜舷筅秈向香箱笑簫筱卸囟行秀臭徐籲血循勳徇衙延衍筵鼽秧徉夭徭移役迤艤劓胤郵牖釉籲禹御毓竽箢粵筠贊簪昝造迮笮簀舴怎乍齇笊箴稹徵徵箏知制智秩徵稚雉種重衆舯螽舟籀朱築竹箸竺邾舳篆追自秭笫租纂笮"
    "癌疤辦半瓣瘢癍北背邶迸閉痹辯辨辮瘭癟並病冰部瓿曾差差瘥闡閶癡瘛瘳牀闖瘡次差慈瓷疵鶿餈瘁痤瘥瘩疸癉疸道導弟羝奠癲癜凋疔凍痘端閼閥痱瘋馮贛疳戇羔閣疙羹龔痼關閨袞馘闞閡闔痕閎瘊冱瘓豢癀閽疾冀瘠痂瘕間兼剪煎翦鶼將獎醬姜漿槳交郊竭癤疥羯竟競靖痙疚疽卷眷桊蠲竣開闞閌痾夔閫闊辣瘌癩闌閬癆冷立痢癘癧療冽凜凌羚六瘤龍聾壟癃礱瘻閭瘰美門悶閩閔瘼逆凝瘧判叛爿疲闢痞癖瓶憑剖普前歉牆羌戕羥妾親酋遒癯闃券拳痊瘸闋闕閏颯瘙痧善閃羶鄯疝韶首瘦閂朔槊送凇竦塑遂羧闥癱痰羰疼剃鵜闐痛童痿闈問聞瘟閿痦襲羲瘕閒羨鷳癇冼翔鯗效新辛歆羞券痃癬丫瘂閻閹閆閼兗養羊癢恙瘍冶意義益毅疫痍瘞癔翊音癮癭癰猷疣閾瘐瘀閱韻奘甑閘痄瘵站章彰瘴鄣着着疹鄭症痔痣瘃疰裝狀壯妝奘戇着資姿恣孳粢尊遵"
    "嬡媼婢妣婊奼嬋娼嫦巢媸巛妲逮刀嫡娣妒娥婀妨妃婦旮艮媾姑嬀好劃畫婚即既姬嫉妓暨嫁建奸嬌姣剿姐婕盡妗婧九鳩娟君郡馗邋姥嫘娌逯媽嬤妹媒媚娩妙嫫姆娜奶嫩妮娘嫋妞怒努奴弩駑胬孥女媲嫖姘嬪娉嬙羣嬈忍刃妊如嫂姍嬗邵劭嬸娠始書恕姝孀妁姒肅她帑迢婷退娃媧婉丸娓嫵媳嬉嫌嫻姓絮旭婿尋巡婭妍嫣姚妖姨姻尹邕娛嫗妤聿媛災甾嫜召晝帚妯姊"
    "俺傲八爸伯佰伴頒傍保飽堡煲備倍憊坌俾便飈颮儐餅伯餑倉傖側岔餷儕饞償倡倘倀傖侈飭傺仇讎儔儲傳創促催隹代袋貸黛岱傣但儋倒登鄧凳低佃爹佚仃侗兌朵剁俄餓餌佴發伐垡飯凡仿分份忿僨風鳳俸佛父付佛伏傅俯斧俘釜伽個鴿頜仡公供佝谷估僱館倌劊傀癸含頷何合盒頜候侯餱化凰會餛貨集飢祭伎偈佶價假佳佼僥伽件健劍儉僭餞牮僵焦餃佼僥僬鷦介借傑偈進今僅饉儆僦俱颶倨倦雋倔俊雋佧侃龕伉倥侉會儈鄶饋傀佬仂儡例俐俚儷傈倆斂倆僚賃領令伶翎瓴餾僂侶倫侖倮饅們命饃侔仫拿佴饢餒恁你倪伲念您恁佞儂儺偶俳佩盆僻仳便偏貧俜僕企俟伽倩僉仟戧僑俏劁伽侵禽衾傾俅全卻饒人任仁飪仞仍儒偌仨傘饊僧傻傷舍佘畲歙什伸使食飾蝕侍仕售舒俞倏毹殳雙似伺飼俟頌餿颼俗夙僳隼他貪倘餳儻絛倜條佻停佟侗仝偷途飩氽佗佤位偉僞偎翁倭伍侮仵兮翕僖歙餼俠仙餡像餉斜偕信餳修休饈鵂敘儇伢儼偃仰佯餚僥爺依億伊儀倚佚仡佾飴飲傭俑優悠佑攸侑餘欲愈餘逾俞覦傴俁飫鵒龠仔債佔仗仉偵值侄仲住佇侏傳饌僮隹倬仔傯俎作做坐佐"
    "絆綁鴇繃比匕弼毖編緶繽剝纏綽弛綢絀純綽紿彈締綈斷緞綞紡費緋紛縫弗縛艴紱紼紺綱縞紇給綆弓緱貫綸緄絎紇紅弘弧緩幻繯繪繢幾給級紀繼績緝畿緘縑強疆犟繮絳繳絞結皆縉經弳糾絹絕緙絝纊纜縲蠡縭練繚綾綹綠縷綸絡縵彌弭糸緬綿黽繆緲緡黽繆繆母納紐轡紕緶縹綺纖繾繰頃綣強繞紉絨縟弱繰繅紗繕紹紳繩綬紓絲鷥緦綏縮彈緹綈統彖紈綰網維緯紋細線弦纖鄉響饗緗綃纈紲繡續緒絢幺疑繹彝縊肄引穎纓潁幼粥鬻紆緣約紜繰繒綻張縝織紙旨彘終粥紂縐綴縋緇總縱綜組纘"
    "哀諳謗褒變遍扁卞斌稟亳詫產顫諂讒昶讖諶誠啻充畜鶉詞卒誕讜帝敵詆諦丶調諜訂讀憝敦訛諤誒方放房訪邡誹扉諷訃該高膏誥詬顧詁詿詭郭裹亥頏毫豪訶劾亨訌護戽扈話譁謊肓諱誨詼諢記計劑譏詰齏齎肩諫譾講誡詰訐謹京旌扃就鷲詎訣譎亢刻課頦誇誆誑斕讕朗郎羸誄裏離戾戀良亮諒吝旒旅率膂巒攣孿欒鑾孌鸞臠論蠃蠻謾盲氓邙袤旄謎謐謬謨謀畝訥旎諾謳旁旆烹翩扁諞評裒譜齊旗棄啓訖綮牽謙譴敲誚譙請綮詘詮讓瓤認扇訕商設誰詵諗市識詩試施適諡熟孰塾率衰誰說誦訟訴謖誶談譚討調亭託彎望忘亡妄謂諉文紊甕於誤誣享詳襄謝諧褻燮許畜詡旋玄諼謔詢訓訊訝言顏諺彥讞謠夜謁議衣譯亦誼裔弈奕詣旖詒贏嬴永詠雍壅饔遊誘於語育於諭諛雜譖詐齋氈譫旃肇詔這謫診證諍衷州謅主諸誅諄諑諮諮諏族卒詛"
    "")
  "ASCII char to traditional Chinese characters.  Powered by OpenCC.
Thanks to BYVoid.")

(defvar pinyinlib--punctuation-alist
  '((?. . "[。.]")
    (?, . "[，,]")
    (?? . "[？?]")
    (?: . "[：:]")
    (?! . "[！!]")
    (?\; . "[；;]")
    (?\\ . "[、\\]")
    (?\( . "[（(]")
    (?\) . "[）)]")
    (?\< . "[《<]")
    (?\> . "[》>]")
    (?~ . "[～~]")
    (?\' . "[‘’「」']")
    (?\" . "[“”『』\"]")
    (?* . "[×*]")
    (?$ . "[￥$]")))

(defun pinyinlib-build-regexp-char
    (char &optional no-punc-p tranditional-p only-chinese-p mixed-p)
  (let ((diff (- char ?a))
        regexp)
    (if (or (>= diff 26) (< diff 0))
        (or (and (not no-punc-p)
                 (assoc-default
                  char
                  pinyinlib--punctuation-alist))
            (regexp-quote (string char)))
      (setq regexp
            (if mixed-p
                (concat (nth diff pinyinlib--traditional-char-table)
                        (nth diff pinyinlib--simplified-char-table))
              (nth diff
                   (if tranditional-p
                       pinyinlib--traditional-char-table
                     pinyinlib--simplified-char-table))))
      (if only-chinese-p
          (if (string= regexp "")
              regexp
            (format "[%s]" regexp))
        (format "[%c%s]" char
                regexp)))))

(defun pinyinlib-build-regexp-string
    (str &optional no-punc-p tranditional-p only-chinese-p mixed-p)
  (mapconcat (lambda (c) (pinyinlib-build-regexp-char
                      c no-punc-p tranditional-p only-chinese-p mixed-p))
             str
             ""))

(provide 'pinyinlib)
;;; pinyinlib.el ends here
