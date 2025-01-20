// Wallmount for a Fujisu Futro S940.
// Copyright (C) 2025 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the 
// GNU General Public License as published by the Free Software Foundation, either version 3 
// of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// the GNU General Public License along with this program.
// If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print] */

PrintThis = "rail"; // ["rail", "plate", "holder", "mount"]

/* [Sizes] */
WallDistance = 9;

RailLenght = 145;
RailWidth = 17;
RailHeigth = 5.0;
RailDistance = 230;  // !!!!!!!!!!!!!!!!!

DistanceHolderWidth = 12;

PlateThickness = 2.2;

AirGap = 0.5;

/* [Futro] */
Lenght = 250;
Width  = 185;
Heigth = 52;

ScrewDistance = 131.5;
ScrewDiameter = 2.8;

/* [Misc] */
ScrewHeadDiameter = 6;

MountingScrewDiameter = 3.6;

Rounding = 4;

/* [Hidden] */

module __Customizer_Limit__ () {}
    shown_by_customizer = false;

$fa = $preview ? 2 : 0.5;
$fs = $preview ? 1 : 0.5;

// If you enable the next line, the $fa and $fs are ignored.
// $fn = $preview ? 12 : 100;
Epsilon = 0.01;
epsilon = Epsilon;

SlotWidth = RailWidth/2+AirGap;
SlotThickness = RailHeigth/2+AirGap;

use <RoundCornersCube.scad>

module Rails()
{
   difference()
   {
      union()
      {
         Plate(h=RailHeigth);
      }

      // slot
      for(y=[1,-1])
      {
         translate([0, y*(RailDistance/2+SlotWidth/2), SlotThickness/2])
            cube([RailLenght+Epsilon, SlotWidth+Epsilon, SlotThickness+Epsilon], center=true);
      }
      MountingDrills();
   }
}
module MountingDrills()
{
      for(x=[0,1,-1])
      {
         for(y=[0,0.5,1,-0.5,-1])
         {
            translate([x*(RailLenght/2-DistanceHolderWidth/2), y*(RailDistance/2-RailWidth/2), -RailHeigth])
               cylinder(d=MountingScrewDiameter, h=3*RailHeigth);
         }
      }
}

module Plate(h=PlateThickness)
{
   difference()
   {
      translate([0,0,h/2])
         RoundCornersCube([RailLenght, RailDistance+RailWidth, h],center=true, r=Rounding);

      MountingDrills();

      // big holes
      for(x=[1,-1])
      {
         w=RailLenght/2-3.25*DistanceHolderWidth;
         translate([x*w, 0,0])
            RoundCornersCube([RailLenght/2-1.5*DistanceHolderWidth, RailDistance-RailWidth, 3*RailHeigth],center=true, r=Rounding);
      }
   }
}

module Holder()
{
   h=SlotThickness-2*AirGap;
   h2=WallDistance;
   difference()
   {
      union()
      {
         translate([0,0, h/2])
            RoundCornersCube([RailLenght, RailWidth-AirGap, h],center=true, r=Rounding);

         for(x=[1,-1])
         {
            l=13;
            translate([x*(RailLenght/2-l/2), -RailWidth/4, h2/2]) 
               RoundCornersCube([l, RailWidth/2, h2], center=true, r=Rounding);
         }
      }

      // drills
      for(x=[1,-1])
      {
         translate([x*ScrewDistance/2, -RailWidth/4, -RailHeigth])
            cylinder(d=ScrewDiameter, h=3*RailHeigth);

         // screw head
         translate([x*ScrewDistance/2, -RailWidth/4, -2])
            cylinder(d=ScrewHeadDiameter, h=WallDistance);
      }
   }
}

module Mount()
{
   color("blue")
      rotate([0,180,0])
         Rails();
   color("brown")
      translate ([0,0,-RailHeigth])
         rotate([0,180,0])
            Plate();
}

module print(what="holder")
{
   if(what == "holder")
   {
      Holder();
   }
   if(what == "rail")
   {
      Rails();
   }
   if(what == "plate")
   {
      Plate();
   }
   if(what == "mount")
   {
      Mount();
   }
}

print(PrintThis);
