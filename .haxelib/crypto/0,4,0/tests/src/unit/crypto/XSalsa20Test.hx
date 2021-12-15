package unit.crypto;

import unit.Test;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.crypto.XSalsa20;

class XSalsa20Test extends Test
{
    var keys = [
        "A6A7251C1E72916D11C2CB214D3C252539121D8E234E652D651FA4C8CFF88030",
		"9E1DA239D155F52AD37F75C7368A536668B051952923AD44F57E75AB588E475A",
		"D5C7F6797B7E7E9C1D7FD2610B2ABF2BC5A7885FB3FF78092FB3ABE8986D35E2",
        "737D7811CE96472EFED12258B78122F11DEAEC8759CCBD71EAC6BBEFA627785C",
		"760158DA09F89BBAB2C99E6997F9523A95FCEF10239BCCA2573B7105F6898D34",
        "27BA7E81E7EDD4E71BE53C07CE8E633138F287E155C7FA9E84C4AD804B7FA1B9",
		"6799D76E5FFB5B4920BC2768BAFD3F8C16554E65EFCF9A16F4683A7A06927C11",
		"F68238C08365BB293D26980A606488D09C2F109EDAFA0BBAE9937B5CC219A49C",
		"45B2BD0DE4ED9293EC3E26C4840FAAF64B7D619D51E9D7A2C7E36C83D584C3DF",
		"FE559C9A282BEB40814D016D6BFCB2C0C0D8BF077B1110B8703A3CE39D70E0E1",
		"0AE10012D7E56614B03DCC89B14BAE9242FFE630F3D7E35CE8BBB97BBC2C92C3",
		"082C539BC5B20F97D767CD3F229EDA80B2ADC4FE49C86329B5CD6250A9877450",
		"3D02BFF3375D403027356B94F514203737EE9A85D2052DB3E4E5A217C259D18A",
		"AD1A5C47688874E6663A0F3FA16FA7EFB7ECADC175C468E5432914BDB480FFC6",
		"053A02BEDD6368C1FB8AFC7A1B199F7F7EA2220C9A4B642A6850091C9D20AB9C",
		"5B14AB0FBED4C58952548A6CB1E0000CF4481421F41288EA0AA84ADD9F7DEB96",
		"D74636E3413A88D85F322CA80FB0BD650BD0BF0134E2329160B69609CD58A4B0"
    ];

    var nonces = [
        "9E645A74E9E0A60D8243ACD9177AB51A1BEB8D5A2F5D700C",
		"AF06F17859DFFA799891C4288F6635B5C5A45EEE9017FD72",
		"744E17312B27969D826444640E9C4A378AE334F185369C95",
        "6FB2EE3DDA6DBD12F1274F126701EC75C35C86607ADB3EDD",
		"43636B2CC346FC8B7C85A19BF507BDC3DAFE953B88C69DBA",
        "EA05F4EBCD2FB6B000DA0612861BA54FF5C176FB601391AA",
		"61AB951921E54FF06D9B77F313A4E49DF7A057D5FD627989",
		"5190B51E9B708624820B5ABDF4E40FAD1FB950AD1ADC2D26",
		"546C8C5D6BE8F90952CAB3F36D7C1957BAAA7A59ABE3D7E5",
		"B076200CC7011259805E18B304092754002723EBEC5D6200",
		"F96B025D6CF46A8A12AC2AF1E2AEF1FB83590ADADAA5C5EA",
		"845543502E8B64912D8F2C8D9FFFB3C69365686587C08D0C",
		"74216C95031895F48C1DBA651555EBFA3CA326A755237025",
		"E489EED440F1AAE1FAC8FB7A9825635454F8F8F1F52E2FCC",
		"C713EEA5C26DAD75AD3F52451E003A9CB0D649F917C89DDE",
		"54BF52B911231B952BA1A6AF8E45B1C5A29D97E2ABAD7C83",
		"EFB606AA1D9D9F0F465EAA7F8165F1AC09F5CB46FECF2A57"
    ];

    var plainText = [
        "093C5E5585579625337BD3AB619D615760D8C5B224A85B1D0EFE0EB8A7EE163ABB0376529FCC09BAB506C618E13CE777D82C3AE9D1A6F972D4160287CBFE60BF2130FC0A6FF6049D0A5C8A82F429231F008082E845D7E189D37F9ED2B464E6B919E6523A8C1210BD52A02A4C3FE406D3085F5068D1909EEECA6369ABC981A42E87FE665583F0AB85AE71F6F84F528E6B397AF86F6917D9754B7320DBDC2FEA81496F2732F532AC78C4E9C6CFB18F8E9BDF74622EB126141416776971A84F94D156BEAF67AECBF2AD412E76E66E8FAD7633F5B6D7F3D64B5C6C69CE29003C6024465AE3B89BE78E915D88B4B5621D",
		"FEAC9D54FC8C115AE247D9A7E919DD76CFCBC72D32CAE4944860817CBDFB8C04E6B1DF76A16517CD33CCF1ACDA9206389E9E318F5966C093CFB3EC2D9EE2DE856437ED581F552F26AC2907609DF8C613B9E33D44BFC21FF79153E9EF81A9D66CC317857F752CC175FD8891FEFEBB7D041E6517C3162D197E2112837D3BC4104312AD35B75EA686E7C70D4EC04746B52FF09C421451459FB59F",
		"7758298C628EB3A4B6963C5445EF66971222BE5D1A4AD839715D1188071739B77CC6E05D5410F963A64167629757",
        "501325FB2645264864DF11FAA17BBD58312B77CAD3D94AC8FB8542F0EB653AD73D7FCE932BB874CB89AC39FC47F8267CF0F0C209F204B2D8578A3BDF461CB6A271A468BEBACCD9685014CCBC9A73618C6A5E778A21CC8416C60AD24DDC417A130D53EDA6DFBFE47D09170A7BE1A708B7B5F3AD464310BE36D9A2A95DC39E83D38667E842EB6411E8A23712297B165F690C2D7CA1B1346E3C1FCCF5CAFD4F8BE0",
		"D30A6D42DFF49F0ED039A306BAE9DEC8D9E88366CC19E8C3642FD58FA0794EBF8029D949730339B0823A51F0F49F0D2C71F1051C1E0E2C86941F172789CDB1B0107413E70F982FF9761877BB526EF1C3EB1106A948D60EF21BD35D32CFD64F89B79ED63ECC5CCA56246AF736766F285D8E6B0DA9CB1CD21020223FFACC5A32",
        "E09FF5D2CB050D69B2D42494BDE5825238C756D6991D99D7A20D1EF0B83C371C89872690B2FC11D5369F4FC4971B6D3D6C078AEF9B0F05C0E61AB89C025168054DEFEB03FEF633858700C58B1262CE011300012673E893E44901DC18EEE3105699C44C805897BDAF776AF1833162A21A",
		"472766",
		"47EC6B1F73C4B7FF5274A0BFD7F45F864812C85A12FBCB3C2CF8A3E90CF66CCF2EACB521E748363C77F52EB426AE57A0C6C78F75AF71284569E79D1A92F949A9D69C4EFC0B69902F1E36D7562765543E2D3942D9F6FF5948D8A312CFF72C1AFD9EA3088AFF7640BFD265F7A9946E606ABC77BCEDAE6BDDC75A0DBA0BD917D73E3BD1268F727E0096345DA1ED25CF553EA7A98FEA6B6F285732DE37431561EE1B3064887FBCBD71935E02",
		"5007C8CD5B3C40E17D7FE423A87AE0CED86BEC1C39DC07A25772F3E96DABD56CD3FD7319F6C9654925F2D87087A700E1B130DA796895D1C9B9ACD62B266144067D373ED51E787498B03C52FAAD16BB3826FA511B0ED2A19A8663F5BA2D6EA7C38E7212E9697D91486C49D8A000B9A1935D6A7FF7EF23E720A45855481440463B4AC8C4F6E7062ADC1F1E1E25D3D65A31812F58A71160",
		"6DB65B9EC8B114A944137C821FD606BE75478D928366D5284096CDEF782FCFF7E8F59CB8FFCDA979757902C5FFA6BC477CEAA4CB5D5EA76F94D91E833F823A6BC78F1055DFA6A97BEA8965C1CDE67A668E001257334A585727D9E0F7C1A06E88D3D25A4E6D9096C968BF138E116A3EBEFFD4BB4808ADB1FD698164BA0A35C709A47F16F1F4435A2345A9194A00B95ABD51851D505809A6077DA9BACA5831AFFF31578C487EE68F2767974A98A7E803AAC788DA98319C4EA8EAA3D394855651F484CEF543F537E35158EE29",
		"EA0F354E96F12BC72BBAA3D12B4A8ED879B042F0689878F46B651CC4116D6F78409B11430B3AAA30B2076891E8E1FA528F2FD169ED93DC9F84E24409EEC2101DAF4D057BE2492D11DE640CBD7B355AD29FB70400FFFD7CD6D425ABEEB732A0EAA4330AF4C656252C4173DEAB653EB85C58462D7AB0F35FD12B613D29D473D330310DC323D3C66348BBDBB68A326324657CAE7B77A9E34358F2CEC50C85609E73056856796E3BE8D62B6E2FE9F953",
		"A96BB7E910281A6DFAD7C8A9C370674F0CEEC1AD8D4F0DE32F9AE4A23ED329E3D6BC708F876640A229153AC0E7281A8188DD77695138F01CDA5F41D5215FD5C6BDD46D982CB73B1EFE2997970A9FDBDB1E768D7E5DB712068D8BA1AF6067B5753495E23E6E1963AF012F9C7CE450BF2DE619D3D59542FB55F3",
		"0D4B0F54FD09AE39BAA5FA4BACCF2E6682E61B257E01F42B8F",
		"AA6C1E53580F03A9ABB73BFDADEDFECADA4C6B0EBE020EF10DB745E54BA861CAF65F0E40DFC520203BB54D29E0A8F78F16B3F1AA525D6BFA33C54726E59988CFBEC78056",
		"8F0A8A164760426567E388840276DE3F95CB5E3FADC6ED3F3E4FE8BC169D9388804DCB94B6587DBB66CB0BD5F87B8E98B52AF37BA290629B858E0E2AA7378047A26602",
		"37FB44A675978B560FF9A4A87011D6F3AD2D37A2C3815B45A3C0E6D1B1D8B1784CD468927C2EE39E1DCCD4765E1C3D676A335BE1CCD6900A45F5D41A317648315D8A8C24ADC64EB285F6AEBA05B9029586353D303F17A807658B9FF790474E1737BD5FDC604AEFF8DFCAF1427DCC3AACBB0256BADCD183ED75A2DC52452F87D3C1ED2AA583472B0AB91CDA20614E9B6FDBDA3B49B098C95823CC72D8E5B717F2314B0324E9CE",
		"F85471B75F6EC81ABAC2799EC09E98E280B2FFD64CA285E5A0109CFB31FFAB2D617B2C2952A2A8A788FC0DA2AF7F530758F74F1AB56391AB5FF2ADBCC5BE2D6C7F49FBE8118104C6FF9A23C6DFE52F57954E6A69DCEE5DB06F514F4A0A572A9A8525D961DAE72269B987189D465DF6107119C7FA790853E063CBA0FAB7800CA932E258880FD74C33C784675BEDAD0E7C09E9CC4D63DD5E9713D5D4A0196E6B562226AC31B4F57C04F90A181973737DDC7E80F364112A9FBB435EBDBCABF7D490CE52"
	];

    var ciphers = [
        "B2AF688E7D8FC4B508C05CC39DD583D6714322C64D7F3E63147AEDE2D9534934B04FF6F337B031815CD094BDBC6D7A92077DCE709412286822EF0737EE47F6B7FFA22F9D53F11DD2B0A3BB9FC01D9A88F9D53C26E9365C2C3C063BC4840BFC812E4B80463E69D179530B25C158F543191CFF993106511AA036043BBC75866AB7E34AFC57E2CCE4934A5FAAE6EABE4F221770183DD060467827C27A354159A081275A291F69D946D6FE28ED0B9CE08206CF484925A51B9498DBDE178DDD3AE91A8581B91682D860F840782F6EEA49DBB9BD721501D2C67122DEA3B7283848C5F13E0C0DE876BD227A856E4DE593A3",
		"2C261A2F4E61A62E1B27689916BF03453FCBC97BB2AF6F329391EF063B5A219BF984D07D70F602D85F6DB61474E9D9F5A2DEECB4FCD90184D16F3B5B5E168EE03EA8C93F3933A22BC3D1A5AE8C2D8B02757C87C073409052A2A8A41E7F487E041F9A49A0997B540E18621CAD3A24F0A56D9B19227929057AB3BA950F6274B121F193E32E06E5388781A1CB57317C0BA6305E910961D01002F0",
		"27B8CFE81416A76301FD1EEC6A4D99675069B2DA2776C360DB1BDFEA7C0AA613913E10F7A60FEC04D11E65F2D64E",
        "6724C372D2E9074DA5E27A6C54B2D703DC1D4C9B1F8D90F00C122E692ACE7700EADCA942544507F1375B6581D5A8FB39981C1C0E6E1FF2140B082E9EC016FCE141D5199647D43B0B68BFD0FEA5E00F468962C7384DD6129AEA6A3FDFE75ABB210ED5607CEF8FA0E152833D5AC37D52E557B91098A322E76A45BBBCF4899E790618AA3F4C2E5E0FC3DE93269A577D77A5502E8EA02F717B1DD2DF1EC69D8B61CA",
		"C815B6B79B64F9369AEC8DCE8C753DF8A50F2BC97C70CE2F014DB33A65AC5816BAC9E30AC08BDDED308C65CB87E28E2E71B677DC25C5A6499C1553555DAF1F55270A56959DFFA0C66F24E0AF00951EC4BB59CCC3A6C5F52E0981647E53E439313A52C40FA7004C855B6E6EB25B212A138E843A9BA46EDB2A039EE82A263ABE",
        "A23E7EF93C5D0667C96D9E404DCBE6BE62026FA98F7A3FF9BA5D458643A16A1CEF7272DC6097A9B52F35983557C77A11B314B4F7D5DC2CCA15EE47616F861873CBFED1D32372171A61E38E447F3CF362B3ABBB2ED4170D89DCB28187B7BFD206A3E026F084A7E0ED63D319DE6BC9AFC0",
		"8FD7DF",
		"36160E88D3500529BA4EDBA17BC24D8CFACA9A0680B3B1FC97CF03F3675B7AC301C883A68C071BC54ACDD3B63AF4A2D72F985E51F9D60A4C7FD481AF10B2FC75E252FDEE7EA6B6453190617DCC6E2FE1CD56585FC2F0B0E97C5C3F8AD7EB4F31BC4890C03882AAC24CC53ACC1982296526690A220271C2F6E326750D3FBDA5D5B63512C831F67830F59AC49AAE330B3E0E02C9EA0091D19841F1B0E13D69C9FBFE8A12D6F30BB734D9D2",
		"8EACFBA568898B10C0957A7D44100685E8763A71A69A8D16BC7B3F88085BB9A2F09642E4D09A9F0AD09D0AAD66B22610C8BD02FF6679BB92C2C026A216BF425C6BE35FB8DAE7FF0C72B0EFD6A18037C70EED0CA90062A49A3C97FDC90A8F9C2EA536BFDC41918A7582C9927FAE47EFAA3DC87967B7887DEE1BF071734C7665901D9105DAE2FDF66B4918E51D8F4A48C60D19FBFBBCBA",
		"4DCE9C8F97A028051B0727F34E1B9EF21F06F0760F36E71713204027902090BA2BB6B13436EE778D9F50530EFBD7A32B0D41443F58CCAEE781C7B716D3A96FDEC0E3764ED7959F34C3941278591EA033B5CBADC0F1916032E9BEBBD1A8395B83FB63B1454BD775BD20B3A2A96F951246AC14DAF68166BA62F6CBFF8BD121AC9498FF8852FD2BE975DF52B5DAEF3829D18EDA42E715022DCBF930D0A789EE6A146C2C7088C35773C63C06B4AF4559856AC199CED86863E4294707825337C5857970EB7FDDEB263781309011",
		"E8ABD48924B54E5B80866BE7D4EBE5CF4274CAFFF08B39CB2D40A8F0B472398AEDC776E0793812FBF1F60078635D2ED86B15EFCDBA60411EE23B07233592A44EC31B1013CE8964236675F8F183AEF885E864F2A72EDF4215B5338FA2B54653DFA1A8C55CE5D95CC605B9B311527F2E3463FFBEC78A9D1D65DABAD2F338769C9F43F133A791A11C7ECA9AF0B771A4AC32963DC8F631A2C11217AC6E1B9430C1AAE1CEEBE22703F429998A8FB8C641",
		"835DA74FC6DE08CBDA277A7966A07C8DCD627E7B17ADDE6D930B6581E3124B8BAAD096F693991FEDB1572930601FC7709541839B8E3FFD5F033D2060D999C6C6E3048276613E648000ACB5212CC632A916AFCE290E20EBDF612D08A6AA4C79A74B070D3F872A861F8DC6BB07614DB515D363349D3A8E3336A3",
		"16C4006C28365190411EB1593814CF15E74C22238F210AFC3D",
		"02FE84CE81E178E7AABDD3BA925A766C3C24756EEFAE33942AF75E8B464556B5997E616F3F2DFC7FCE91848AFD79912D9FB55201B5813A5A074D2C0D4292C1FD441807C5",
		"516710E59843E6FBD4F25D0D8CA0EC0D47D39D125E9DAD987E0518D49107014CB0AE405E30C2EB3794750BCA142CE95E290CF95ABE15E822823E2E7D3AB21BC8FBD445",
		"AE6DEB5D6CE43D4B09D0E6B1C0E9F46157BCD8AB50EAA3197FF9FA2BF7AF649EB52C68544FD3ADFE6B1EB316F1F23538D470C30DBFEC7E57B60CBCD096C782E7736B669199C8253E70214CF2A098FDA8EAC5DA79A9496A3AAE754D03B17C6D70D1027F42BF7F95CE3D1D9C338854E158FCC803E4D6262FB639521E47116EF78A7A437CA9427BA645CD646832FEAB822A208278E45E93E118D780B988D65397EDDFD7A819526E",
		"B2B795FE6C1D4C83C1327E015A67D4465FD8E32813575CBAB263E20EF05864D2DC17E0E4EB81436ADFE9F638DCC1C8D78F6B0306BAF938E5D2AB0B3E05E735CC6FFF2D6E02E3D60484BEA7C7A8E13E23197FEA7B04D47D48F4A4E5944174539492800D3EF51E2EE5E4C8A0BDF050C2DD3DD74FCE5E7E5C37364F7547A11480A3063B9A0A157B15B10A5A954DE2731CED055AA2E2767F0891D4329C426F3808EE867BED0DC75B5922B7CFB895700FDA016105A4C7B7F0BB90F029F6BBCB04AC36AC16"
		];

    public function test_xsalsa20():Void
    {
        trace("XSalsa20 for "+keys.length+" keys");
        var time = Timer.stamp();
        for(i in 0...keys.length)
        {
            var key = Bytes.ofHex(keys[i]);
            var nonce = Bytes.ofHex(nonces[i]);
            var text = Bytes.ofHex(plainText[i]);
            var xsalsa20 = new XSalsa20();
            xsalsa20.init(key,nonce);
            var enc = xsalsa20.encrypt(text);
            eq( enc.toHex().toUpperCase(), ciphers[i] );
            xsalsa20.reset();
            var decr = xsalsa20.decrypt(enc);
            eq( decr.toHex().toUpperCase(), plainText[i] );
            }
        time = Timer.stamp()-time;
        trace("Finished : "+time+" seconds");
    }
}