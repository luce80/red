Red/System [
    Note: "Auto-generated lexical scanner transitions table"
] 
    #enum lex-states! [
        S_START 
        S_LINE_CMT 
        S_LINE_STR 
        S_SKIP_STR 
        S_M_STRING 
        S_SKIP_MSTR 
        S_FILE_1ST 
        S_FILE 
        S_FILE_STR 
        S_HDPER_ST 
        S_HERDOC_ST 
        S_HDPER_C0 
        S_HDPER_CL 
        S_SLASH 
        S_SLASH_N 
        S_SHARP 
        S_BINARY 
        S_LINE_CMT2 
        S_CHAR 
        S_SKIP_CHAR 
        S_CONSTRUCT 
        S_ISSUE 
        S_NUMBER 
        S_DOTNUM 
        S_DECIMAL 
        S_DECEXP 
        S_DECX 
        S_DEC_SPECIAL 
        S_TUPLE 
        S_DATE 
        S_TIME_1ST 
        S_TIME 
        S_PAIR_1ST 
        S_PAIR 
        S_MONEY_1ST 
        S_MONEY 
        S_MONEY_DEC 
        S_HEX 
        S_HEX_END 
        S_HEX_END2 
        S_LESSER 
        S_TAG 
        S_TAG_STR 
        S_TAG_STR2 
        S_SIGN 
        S_DOTWORD 
        S_DOTDEC 
        S_WORD_1ST 
        S_WORD 
        S_WORDSET 
        S_PERCENT 
        S_URL 
        S_EMAIL 
        S_REF 
        S_PATH 
        S_PATH_NUM 
        S_PATH_W1ST 
        S_PATH_WORD 
        S_PATH_SHARP 
        S_PATH_SIGN 
        --EXIT_STATES-- 
        T_EOF 
        T_ERROR 
        T_BLK_OP 
        T_BLK_CL 
        T_PAR_OP 
        T_PAR_CL 
        T_MSTR_OP 
        T_MSTR_CL 
        T_MAP_OP 
        T_PATH 
        T_CONS_MK 
        T_CMT 
        T_STRING 
        T_WORD 
        T_ISSUE 
        T_INTEGER 
        T_REFINE 
        T_CHAR 
        T_FILE 
        T_BINARY 
        T_PERCENT 
        T_FLOAT 
        T_FLOAT_SP 
        T_TUPLE 
        T_DATE 
        T_PAIR 
        T_TIME 
        T_MONEY 
        T_TAG 
        T_URL 
        T_EMAIL 
        T_HEX 
        T_RAWSTRING 
        T_REF
    ] 
    skip-table: #{
0100000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000
} 
    type-table: #{
00000707070708080807070707130F1429000A0A00140B0C0C0C0C0C272F2B2B
25253131310B0F0B2C2C2C2C0F0F0C0F0F100F092D32190B0F0F140F00002200
000000000700000000070F140B130A0829260C0C272F252B312C092D0B0732
} 
    transitions: #{
000016163F404142433E020F2F2F303030302530250D3E283030063E01352D22
2C2C3E30303E3D01480101010101010101010101010101010101010101010101
0101010101010101010101013E3D020202020202020202024902020202020202
020202020202020202020202020202020302023E3E0202020202020202020202
02020202020202020202020202020202020202020202020202023E3D04040404
0404040443440404040404040404040404040404040404040404040404040504
043E3E0404040404040404040404040404040404040404040404040404040404
04040404040404043E3D4A4A07074A4A4A4A0A4A080707320707070707070707
0707070709074A4A070707070707073E4A4F4F07074F4F4F4F4F4F3E07074F07
070707070707070707070707074F4F070707070707073E4F0808080808080808
08084F08080808080808080808080808080808080808080808080808083E3E4A
4A3E3E4A4A4A4A0A4A4A3E3E3E3E3E3E3E3E3E3E3E4A3E3E3E093E4A3E3E3E3E
3E3E3E3E3E4A0A0A0A0A0A0A0A0A0A0B0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
0A0A0A0A0A0A0A0A0A0A0A3E3E0A0A0A0A0A0A0A0A0A0B0A0A0A0A0A0A0A0A0A
0A0A0A0A0A0A0A0C0A0A0A0A0A0A0A0A0A0A3E3E5D5D3E3E5D5D5D5D5D3E5D3E
3E3E3E3E3E3E3E3E3E3E3E5D3E3E0C3E5D3E3E3E3E3E3E3E3E3E5D4D4D0D0D4D
4D4D4D4D4D4D0D0D0D0D0D0D0D0D0D0D0E0D0D0D0D0D0D4D4D0D0D0D0D0D0D0D
3E4D4A4A30304A4A4A4A4A4A4A3E3030303030303030300E303030303E304A4A
303E30303030303E4A4B4B1515143E453E103E1215153E151515151515151515
3E3E3E153E4B4B151515151515153E4B101010103E3E3E3E3E503E3E3E3E1010
1010101010103E3E3E103E3E113E3E3E103E3E3E103E3E111011111111111111
111111111111111111111111111111111111111111111111111111113E3D1212
12121212121212124E1212121212121212121212121212121212121212121212
1312123E4E121212121212121212121212121212121212121212121212121212
121212121212121212123E3E1414141414471414141414141414141414141414
14141414141414141414141414141414143E3E4B4B15154B4B4B4B4B4B4B1515
1515151515151515151515151515154B4B151515151515153E4B4C4C16164C4C
4C4C4C4C4C0F161E201D27191A3E251D3E4C3E3E51174C34173E3E1D3E3E3E3E
4C52521818525252525252521B183E203E3E19193E3E523E523E3E513E523E3E
3E3E3E3E3E3E3E5252521818525252525252523E3E52203E3E19193E3E523E52
3E3E513E3E341C3E3E3E3E3E3E3E5252521919525252525252523E3E523E3E3E
3E3E3E3E523E523E3E3E3E3E343E3E19193E3E3E3E5252521A1A525252525252
523E3E523E3E273E253E25523E523E3E513E3E341C3E19193E3E3E3E52535352
53535353535353531B53531B1B1B1B1B1B1B5353531B1B535353531B531B1B53
1B1B3E5354541C1C545454545454543E3E543E3E3E3E3E3E3E543E543E3E3E3E
3E3E1C3E3E3E3E3E3E3E5455551D1D555555555555551D1D1D1D1D1D1D1D1D1D
1D1D551D1D3E1D55551D551D1D3E3E1D3E553E3E1F1F3E3E3E3E3E3E3E3E3E3E
3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E57571F1F575757
575757573E3E1F3E3E3E3E3E3E3E573E573E3E3E3E573E1F3E3E3E3E3E3E3E57
3E3E21213E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E343E3E
21213E3E3E3E3E56562121565656565656563E3E563E3E3E21213E3E563E563E
3E3E3E5634213E3E3E3E3E3E3E563E3E23233E3E3E3E3E3E3E3E3E3E3E3E3E3E
3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E5858232358585858585858
5823583E3E3E3E3E3E3E583E583E3E3E24583E243E3E3E3E3E3E3E5858582424
585858585858585824583E3E3E3E3E3E3E583E583E3E3E3E583E3E3E3E3E3E3E
3E3E584A4A25254A4A4A4A4A4A4A3E303130302630253025464A3030303E3E4A
34302330303030303E4A5C5C30305C5C5C5C5C5C5C3E30313030303030303046
5C3030303E3E5C34302330303030303E5C5C5C3E3E5C5C5C5C5C5C5C3E3E3E3E
3E3E3E3E3E3E465C5C3E3E3E3E5C343E233E3E3E3E3E3E5C4A4A29294A4A4A4A
4A4A4A292B4A29292929292929292928303029294A4A292929302929293E4A29
2929292929292929292A292B2929292929292929292929592929292929292929
292929293E3E2A2A2A2A2A2A2A2A2A2A292A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
2A2A2A2A2A2A2A2A2A2A2A3E3E2B2B2B2B2B2B2B2B2B2B2B2B292B2B2B2B2B2B
2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B3E3E4A4A16164A4A4A4A4A4A4A3E
3E3030303030303030304A3E30303E304A302D2330303E30303E4A4A4A2E2E4A
4A4A4A4A4A4A3E30313030302E2E3030464A3030303E3E4A34303E2E2E303030
3E4A52522E2E525252525252523E3E52203E3E2E2E3E3E523E523E3E513E3E3E
3E3E2E2E3E3E3E3E523E3E3E3E3E3E3E3E3E3E3E3E3E3E303030303030300D3E
303030323E3E3E303E30303E30303E3E4A4A30304A4A4A4A4A4A4A3E30313030
3030303030464A4A30303E3E4A34302230303030303E4A4A4A33334A4A4A4A4A
4A4A33333333333333333333334A3E333333334A33333333333333333E4A4A4A
3E3E4A4A4A4A4A4A3E3E3E3E3E3E3E3E3E3E3E3E4A3E3E3E323E4A3E3E3E3E3E
3E3E3E3E4A5A5A33335A5A5A5A5A5A5A333E3333333333333333335A5A3E3333
5A5A33333E33333E33333E5A5B5B34345B5B5B5B5B5B5B3E3E3E343434343434
345B5B5B3E3E343E5B3E343E34343E34343E5B5E5E35355E5E5E5E5E5E5E3E3E
3535353535353535353E5E3E3E353E5E3E353E35353E35353E5E3E3E37373E3E
41423E3E023A3838393939393939393E3E2839393E3E3E34393E3B3B3E39393E
3E4C4C37374C4C4C4C4C4C4C3E164C203E3E19193E3E4C3E4C3E3E51174C3417
3E3E3E3E3E3E3E4C3E3E3E3E3E3E3E3E3E3E3E3E3E3E393939393939393E3E39
39393E3E3E3E393E39393E39393E3E4A4A39394A4A4A4A4A4A4A3E394A393939
393939394A4A3939393E3E4A34393E39393939393E4A4B4B1515143E3E3E3E3E
1215153E1515151515151515153E3E3E153E4B4B151515151515153E4B4A4A37
374A4A4A4A4A4A4A3E3E3030303030303030304A3E30303E304A30303030303E
30303E4A
}
