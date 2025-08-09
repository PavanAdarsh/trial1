#Directories
MSPGCC_ROOT_DIR = /home/pavan/Downloads/ccs2020/ccs/ccs_base/msp430

#MSPGCC_BIN_DIR = 
MSP430_INCLUDE_DIR = $(MSPGCC_ROOT_DIR)/include_gcc
INCLUDE_DIRS = $(MSP430_INCLUDE_DIR)
LIB_DIRS = $(MSP430_INCLUDE_DIR)

TI_CCS_DIR = /home/pavan/Downloads/ccs2020/ccs
DEBUG_BIN_DIR = $(TI_CCS_DIR)/ccs-base/DebugServer/bin
DEBUG_DRIVERS_DIR = $(TI_CCS_DIR)/ccs-base/DebugServer/drivers

BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

#Toolchain
CC = msp430-elf-gcc -mmcu=msp430g2553
DEBUG = $(LD_LIBRARY_PATH=$(DEBUG_DRIVERS_DIR) $(DEBUG_BIN_DIR)/ mspdebug
CPPCHECK = cppcheck

#Files
TARGET = $(BIN_DIR)/blink

SOURCE = main.c \
		led.c

OBJECTS = $(OBJ_DIR)/main.o \
		$(OBJ_DIR)/led.o
	
	
#Flags
WFLAGS = -Wall #-Wextra -Werror -Wshadow
CFLAGS = $(WFLAGS) $(addprefix -I,$(INCLUDE_DIRS)) -Og -g #compiler flag
LDFLAGS = $(addprefix -L,$(LIB_DIRS)) #linker flag

#Build
#Linking
$(TARGET) : $(OBJECTS)
	@mkdir -p $(dir $@) #directory is created. p flag to avoid error in case directory exists. @ to not print it in terminal
	$(CC) \
	$(LDFLAGS) \
	$^ -o $@
	
#Compiling
$(OBJ_DIR)/%.o: %.c 
	@mkdir -p $(dir $@)
#making it generic for all files of type .o (pattern rule)		
	$(CC) $(CFLAGS) -c -o $@ $^
#automatic variables in place of input ($^) and output ($@)

#Phonies
.PHONY: all clean flash cppcheck

all: $(TARGET)
clean: 
	rm -r $(BUILD_DIR)
flash: 
	$(DEBUG) tilib "prog$(TARGET)"
cppcheck: 
	@$(CPPCHECK) --quiet --force --enable=all --error-exitcode=1 \
	--inline-suppr \
	-I $(INCLUDE_DIRS) \
	$(SOURCE) \
	-I printf 


