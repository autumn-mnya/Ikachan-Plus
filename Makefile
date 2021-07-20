WINDRES = windres

BUILD_DIRECTORY = game

ifeq ($(RELEASE), 1)
	CXXFLAGS = -O3
	LDFLAGS = -s
	FILENAME_DEF = dxIka.exe
else
	CXXFLAGS = -Og -ggdb3
	FILENAME_DEF = dxIka_debug.exe
endif

FILENAME ?= $(FILENAME_DEF)

CXXFLAGS += -std=c++98 -MMD -MP -MF $@.d
LIBS += -lkernel32 -lgdi32 -lddraw -ldinput -ldsound -lversion -lshlwapi -limm32 -lwinmm -ldxguid

ifeq ($(STATIC), 1)
	LDFLAGS += -static
endif

SOURCES = \
	Ikachan/System \
	Ikachan/Sound \
	Ikachan/Player \
	Ikachan/PiyoPiyo \
	Ikachan/PixelScript \
	Ikachan/Opening \
	Ikachan/NpChar \
	Ikachan/Map \
	Ikachan/Item \
	Ikachan/Generic \
	Ikachan/Game \
	Ikachan/Flags \
	Ikachan/EventScript \
	Ikachan/Effect \
	Ikachan/Editor \
	Ikachan/Draw \
	Ikachan/Dialog \
	Ikachan/Boss 

OBJECTS = $(addprefix obj/$(FILENAME)/, $(addsuffix .o, $(SOURCES)))
DEPENDENCIES = $(addprefix obj/$(FILENAME)/, $(addsuffix .o.d, $(SOURCES)))

OBJECTS += obj/$(FILENAME)/windows_resources.o

$(BUILD_DIRECTORY)/$(FILENAME): $(OBJECTS)
	@mkdir -p $(@D)
	@echo Linking $@
	@$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@ $(LIBS)

obj/$(FILENAME)/%.o: %.cpp
	@mkdir -p $(@D)
	@echo Compiling $<
	@$(CXX) $(CXXFLAGS) $< -o $@ -c

include $(wildcard $(DEPENDENCIES))

obj/$(FILENAME)/windows_resources.o: Ikachan/Resource/Ikachan.rc
	@mkdir -p $(@D)
	@$(WINDRES) $< $@

# TODO
clean:
	@rm -rf obj
