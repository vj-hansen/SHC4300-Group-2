
#ifndef POINT_H
#define POINT_H

class Point {
private:
    double x_coord;
    double y_coord;
    double z_coord;

public:
    Point();  //-Default constructor
    Point(double, double, double); //-Overloaded constructor
    
    ~Point(){;} //-Destructor
    
    //-Accessors (const = not modifiable)
    int getX_coord() const {return x_coord;}    //-return x coordinate
    int getY_coord() const {return y_coord;}    //-return y coordinate
    int getZ_coord() const {return z_coord;}    //-return z coordinate
    
    void printData();
    double calcDist(const Point &p) const;
};

#endif