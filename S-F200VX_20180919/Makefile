###################################################
#工具链定义处
###################################################
TOOLCHAIN_DIR = C:/Program Files (x86)/chipsea/CSU-IDE V4.0.8/chipsea/tools/Compiler/ASM
ASM	   				= "$(TOOLCHAIN_DIR)\csua.exe"
RM	   				= del /F 1>NUL 2>NUL
ECHO					= @echo //-----------------------------------------------------------------------



###################################################
#编译选项定义处
###################################################
OUTPUT_DIR            = E:\工作项目暂存区\电子秤\电子秤项目\X_新域\S-F200_WIFI_FAT_20180116\A_版本\6035Wifi八电极_20180919\S-F200VX_20180919\.\Release
SOURCE_MAIN_FILE_NAME = S-Fxxx
SOURCE_MAIN_FILE_PATH = E:\工作项目暂存区\电子秤\电子秤项目\X_新域\S-F200_WIFI_FAT_20180116\A_版本\6035Wifi八电极_20180919\S-F200VX_20180919\/
GENERATE_DAT_FILE			= 1
BODY_NAME							= CSU18MB86
INST_TYPE							= 1
ROM_WIDTH							= 16
ROM_SPACE						  = 8191
APPEND_ROM_SIZE				= 0
LIMIT_SPACE						= 8191
ASM_LANGUAGE					= eng
FILL_DATA_VALUE				= 0xff
CODE_OPTION						= 0x2080:0x0001;
ASM_INCLUDE_PATH			= %%AsmIncludePath%%
UNIT_COMPILER_ASM_FILE= 
CX_COMPILER_OPTION		= -debug 1
ASM_OPTION						= 
LINKER_OPTION					= -fill 1
#LINKER_OPTION				= -fill $(FILL_DATA_VALUE) -cop $(CODE_OPTION)



###################################################
#编译单一文件处
###################################################
compile_unit_asm_file : "$(UNIT_COMPILER_ASM_FILE)"
	$(ASM) -file "$(UNIT_COMPILER_ASM_FILE)" -spath "$(SOURCE_MAIN_FILE_PATH)/" -opath "$(OUTPUT_DIR)/" -chipn $(BODY_NAME) -inst $(INST_TYPE) -romb $(ROM_WIDTH) -space $(ROM_SPACE) -aspace $(APPEND_ROM_SIZE) -limitspace $(LIMIT_SPACE) -lang $(ASM_LANGUAGE) $(CX_COMPILER_OPTION) $(LINKER_OPTION) -cop $(CODE_OPTION)
	$(ECHO)



###################################################
#命令定义处
###################################################
.PHONY : build
build  : outputdir binfile

.PHONY : rebuild
rebuild: outputdir clean build

.PHONY : clean
clean :
	$(RM)  "$(OUTPUT_DIR)\$(SOURCE_MAIN_FILE_NAME).hex"
	$(RM)  "$(OUTPUT_DIR)\*.obj"
	$(RM)  "$(OUTPUT_DIR)\*.dat"
	$(RM)  "$(OUTPUT_DIR)\*.txt"
	$(RM)  "$(OUTPUT_DIR)\*.sbms"
	$(ECHO)

outputdir:
	if not exist "$(OUTPUT_DIR)\$(NULL)" mkdir "$(OUTPUT_DIR)"
	$(ECHO)
	
binfile: 
	$(ASM) -file "$(SOURCE_MAIN_FILE_NAME)" -spath "$(SOURCE_MAIN_FILE_PATH)/" -opath "$(OUTPUT_DIR)/" -chipn $(BODY_NAME) -inst $(INST_TYPE) -romb $(ROM_WIDTH) -space $(ROM_SPACE) -aspace $(APPEND_ROM_SIZE) -limitspace $(LIMIT_SPACE) -lang $(ASM_LANGUAGE) $(CX_COMPILER_OPTION) $(LINKER_OPTION) -cop $(CODE_OPTION)
	$(ECHO)
		
.PHONY : compile
compile : compile_unit_asm_file

