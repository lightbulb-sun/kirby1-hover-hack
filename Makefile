TETRIS_ROM = kirby1.gb
NAME = hack
BUILD_DIR = build
SOURCE_FILE = $(NAME).asm
OBJECT_FILE = $(BUILD_DIR)/$(NAME).o
OUTPUT_ROM = $(BUILD_DIR)/$(NAME).gb

all:
	mkdir -p $(BUILD_DIR)
	rgbasm  -E $(SOURCE_FILE) -o $(OBJECT_FILE)
	rgblink -O $(TETRIS_ROM) -o $(OUTPUT_ROM) $(OBJECT_FILE)
	rgbfix -f gh $(OUTPUT_ROM)

clean:
	rm -rf $(BUILD_DIR)
