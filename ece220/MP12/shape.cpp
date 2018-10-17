#include "shape.hpp"
#define PI 3.1415926

//Base class
//Please implement Shape's member functions
//constructor, getName()
//

Shape::Shape(string name)
{
    name_ = name;
}

string Shape::getName()
{
    return name_;
}

//Base class' constructor should be called in derived classes'
//constructor to initizlize Shape's private variable

//Rectangle
//Please implement the member functions of Rectangle:
//constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here

// constructor
Rectangle::Rectangle(double width, double length):Shape("Rectangle")
{
    width_ = width;
    length_ = length;
}

// getArea()
double Rectangle::getArea() const
{
    return (width_ * length_);
}

// getVolume()
double Rectangle::getVolume() const
{
    return 0.0;
}

// operator +
Rectangle Rectangle::operator + (const Rectangle& rec)
{
    double w, l;
    w = width_ + rec.getWidth();
    l = length_ + rec.getLength();
    return Rectangle(w, l);
}

// operator -
Rectangle Rectangle::operator - (const Rectangle& rec)
{
    double w, l;
    w = max(0.0, width_ - rec.getWidth());
    l = max(0.0, length_ - rec.getLength());
    return Rectangle(w, l);
}

double Rectangle::getWidth()const{return width_;}
double Rectangle::getLength()const{return length_;}


//Circle
//Please implement the member functions of Circle:
//constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here

// constructor
Circle::Circle(double radius):Shape("Circle")
{
    radius_ = radius;
}


// getArea()
double Circle::getArea() const
{
    return (radius_ * radius_ * PI);
}

// getVolume()
double Circle::getVolume() const
{
    return 0.0;
}

// operator +
Circle Circle::operator + (const Circle& cir)
{
    return Circle(radius_ + cir.getRadius());
}

// operator -
Circle Circle::operator - (const Circle& cir)
{
    double r;
    r = max(0.0, radius_ - cir.getRadius());
    return Circle(r);
}

double Circle::getRadius()const{return radius_;}

//Sphere
//Please implement the member functions of Sphere:
//constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here

// constructor
Sphere::Sphere(double radius):Shape("Sphere")
{
    radius_ = radius;
}

// getArea
double Sphere::getArea() const
{
    return (4.0 * PI * radius_ * radius_);
}

// getVolume
double Sphere::getVolume() const
{
    return (4.0 / 3.0 * PI * radius_ * radius_ * radius_);
}

// operator +
Sphere Sphere::operator + (const Sphere& sph)
{
    return Sphere(radius_+sph.getRadius());
}

// operator -
Sphere Sphere::operator - (const Sphere& sph)
{
    return Sphere(max(0.0, radius_ - sph.getRadius()));
}

double Sphere::getRadius()const{return radius_;}

//Rectprism
//Please implement the member functions of RectPrism:
//constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here

//constructor
RectPrism::RectPrism(double width, double length, double height):Shape("RectPrism")
{
    width_ = width;
    length_ = length;
    height_ = height;
}

// getArea
double RectPrism::getArea() const
{
    return (2.0 * (width_*length_+width_*height_+length_*height_));
}

// getVolume
double RectPrism::getVolume() const
{
    return width_ * length_ * height_;
}

// operator +
RectPrism RectPrism::operator + (const RectPrism& rectp)
{
    double w, l, h;
    w = width_ + rectp.getWidth();
    l = length_ + rectp.getLength();
    h = height_ + rectp.getHeight();
    return RectPrism(w, l, h);
}

// operator -
RectPrism RectPrism::operator - (const RectPrism& rectp)
{
    double w, l, h;
    w = max(0.0, width_ - rectp.getWidth());
    l = max(0.0, length_ - rectp.getLength());
    h = max(0.0, height_ - rectp.getHeight());
    return RectPrism(w, l, h);
}

double RectPrism::getWidth()const{return width_;}
double RectPrism::getHeight()const{return height_;}
double RectPrism::getLength()const{return length_;}



// Read shapes from test.txt and initialize the objects
// Return a vector of pointers that points to the objects
vector<Shape*> CreateShapes(char* file_name){
	//@@Insert your code here
  // Create an empty vector
  vector<Shape*> all_shapes = vector<Shape*>();
  // open the input file
  ifstream ifs (file_name, std::ifstream::in);
  int num_shapes;
  ifs >> num_shapes;
  for (int i = 0; i < num_shapes; i++){
      string name;
      ifs >> name;
      Shape* new_shape;
      if (name == "Circle"){
          double r;
          ifs >> r;
          new_shape = new Circle(r);
      }
      else if (name == "Rectangle"){
          double w, l;
          ifs >> w >> l;
          new_shape = new Rectangle(w, l);
      }
      else if (name == "Sphere"){
          double r;
          ifs >> r;
          new_shape = new Sphere(r);
      }
      else{
          double w, l, h;
          ifs >> w >> l >> h;
          new_shape = new RectPrism(w, l, h);
      }
      all_shapes.push_back(new_shape);
  }
  // close the input file
  ifs.close();
	return all_shapes; // please remeber to modify this line to return the correct value
}

// call getArea() of each object
// return the max area
double MaxArea(vector<Shape*> shapes){
	double max_area = 0.0;
	//@@Insert your code here
  int num_of_shapes = shapes.size();
  for (int i = 0; i < num_of_shapes; i++){
      if (shapes[i]->getArea() > max_area)
          max_area = shapes[i]->getArea();
  }
	return max_area;
}


// call getVolume() of each object
// return the max volume
double MaxVolume(vector<Shape*> shapes){
	double max_volume = 0;
	//@@Insert your code here
  int num_of_shapes = shapes.size();
  for (int i = 0; i < num_of_shapes; i++){
      if (shapes[i]->getVolume() > max_volume)
          max_volume = shapes[i]->getVolume();
  }
	return max_volume;
}
