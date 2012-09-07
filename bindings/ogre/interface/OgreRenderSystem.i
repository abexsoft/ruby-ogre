%{
#include <OgreRenderSystem.h>
%}

%extend Ogre::RenderSystem {
	VALUE getConfigOptionHash() {
		VALUE hash = rb_hash_new();

		Ogre::ConfigOptionMap& options = self->getConfigOptions();
		for (Ogre::ConfigOptionMap::iterator it = options.begin(); it != options.end(); it++){
			//VALUE key = SWIG_From_std_string(static_cast< std::string >((it->first)));
			//std::string& s = static_cast< std::string >((it->first));
			VALUE key = SWIG_FromCharPtrAndSize(it->first.data(), it->first.size());
			VALUE value = SWIG_NewPointerObj(SWIG_as_voidptr(&(it->second)), SWIGTYPE_p_Ogre___ConfigOption, 0 |  0 );

			rb_hash_aset(hash, key, value);			
		}
		return hash;
	}
}

%include OgreRenderSystem.h

