# needed DEPS_DIR

OGRE_INC = \
	-I$(DEPS_DIR)/include/OGRE \
	-I$(DEPS_DIR)/include/OGRE/GLX \
	-I$(DEPS_DIR)/include/OGRE/Paging \
	-I$(DEPS_DIR)/include/OGRE/RTShaderSystem/ \
	-I$(DEPS_DIR)/include/OGRE/Terrain/ 

OIS_INC = \
	-I$(DEPS_DIR)/include/OIS

PROC_INC = \
	-I$(DEPS_DIR)/include/OgreProcedural
