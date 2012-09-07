%{
#include <OgreTerrainGroup.h>

%}

%feature("valuewrapper") Ogre::TerrainGroup::RayResult;
%nestedworkaround Ogre::TerrainGroup::TerrainSlot;


%extend Ogre::TerrainGroup {
	void setDefaultImportSettings(float y){
		Ogre::Terrain::ImportData& defaultimp = self->getDefaultImportSettings();
		defaultimp.terrainSize = 513;
		defaultimp.pos.y = y;
		defaultimp.worldSize = 12000.0f;
		defaultimp.inputScale = 600;
		defaultimp.minBatchSize = 33;
		defaultimp.maxBatchSize = 65;
		// textures
		defaultimp.layerList.resize(3);
		defaultimp.layerList[0].worldSize = 100;
		defaultimp.layerList[0].textureNames.push_back("dirt_grayrocky_diffusespecular.dds");
		defaultimp.layerList[0].textureNames.push_back("dirt_grayrocky_normalheight.dds");
		defaultimp.layerList[1].worldSize = 30;
		defaultimp.layerList[1].textureNames.push_back("grass_green-01_diffusespecular.dds");
		defaultimp.layerList[1].textureNames.push_back("grass_green-01_normalheight.dds");
		defaultimp.layerList[2].worldSize = 200;
		defaultimp.layerList[2].textureNames.push_back("growth_weirdfungus-03_diffusespecular.dds");
		defaultimp.layerList[2].textureNames.push_back("growth_weirdfungus-03_normalheight.dds");		
	}

	void initBlendMaps(){
		Ogre::TerrainGroup::TerrainIterator ti = self->getTerrainIterator();
		while(ti.hasMoreElements())
		{
			Ogre::Terrain* terrain = ti.getNext()->instance;

			Ogre::TerrainLayerBlendMap* blendMap0 = terrain->getLayerBlendMap(1);
			Ogre::TerrainLayerBlendMap* blendMap1 = terrain->getLayerBlendMap(2);
			Ogre::Real minHeight0 = 70;
			Ogre::Real fadeDist0 = 40;
			Ogre::Real minHeight1 = 70;
			Ogre::Real fadeDist1 = 15;
			float* pBlend0 = blendMap0->getBlendPointer();
			float* pBlend1 = blendMap1->getBlendPointer();
			for (Ogre::uint16 y = 0; y < terrain->getLayerBlendMapSize(); ++y)
			{
				for (Ogre::uint16 x = 0; x < terrain->getLayerBlendMapSize(); ++x)
				{
					Ogre::Real tx, ty;
					
					blendMap0->convertImageToTerrainSpace(x, y, &tx, &ty);
					Ogre::Real height = terrain->getHeightAtTerrainPosition(tx, ty);
					Ogre::Real val = (height - minHeight0) / fadeDist0;
					val = Ogre::Math::Clamp(val, (Ogre::Real)0, (Ogre::Real)1);
					*pBlend0++ = val;
					
					val = (height - minHeight1) / fadeDist1;
					val = Ogre::Math::Clamp(val, (Ogre::Real)0, (Ogre::Real)1);
					*pBlend1++ = val;
				}
			}
			blendMap0->dirty();
			blendMap1->dirty();
			blendMap0->update();
			blendMap1->update();
		}
	}
		

}

%include OgreTerrainGroup.h



%{
typedef Ogre::TerrainGroup::TerrainSlot TerrainSlot;
%}
