namespace Ogre {

class AnyVALUE : public Any
{
   public:
        AnyVALUE(): Any()
	{
        }

	void setVALUE(VALUE value) {
		value_ = value;
	}

	VALUE getVALUE(){
		return value_;
	}
private:
	VALUE value_;
};

}
