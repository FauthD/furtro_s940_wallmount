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

PrintThis = "rail"; // ["rail", "plate", "holder", "mount", "futro"]

/* [Sizes] */
CaseDistance = 7;
RailWidth = 15;

DistanceHolderWidth = 12;

PlateThickness = 2.4;

AirGap = 0.3;

/* [Futro] */
Lenght = 250;
Width  = 185;
Heigth = 52;
ScrewOffset = 12;

ScrewDistanceShort = 131.5;
ScrewDistanceLong = 237.0;
ScrewToCorner = 6;
ScrewDiameter = 2.8;

/* [Misc] */
ScrewHeadDiameter = 6;
MountingScrewDiameter = 3.6;
MountingScrewDistance = 50;
Rounding = 4;
ExtraWallDistance = 12;

DrillHeigth = 5.0;

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
SlotThickness = PlateThickness+AirGap;

RailLenght = 2*MountingScrewDistance + 20;
RailDistance = ScrewDistanceLong - ScrewToCorner - RailWidth/2;

use <RoundCornersCube.scad>

module Rails()
{
   difference()
   {
      union()
      {
         translate([0, 0, SlotThickness])
            Plate(l=RailDistance, h=PlateThickness);
         Plate(l=RailDistance-2*SlotWidth-2*2*AirGap, h=SlotThickness);
      }

      MountingDrills();
      // sink the screws a bit
      h=3;
      translate([0, 0, -h/2+SlotThickness+PlateThickness+Epsilon])
         MountingDrills(d=8, h=h);
   }
}

module MountingDrills(d=MountingScrewDiameter, h=5*DrillHeigth+ExtraWallDistance)
{
      for(x=[0,1,-1])
      {
         for(y=[0,1.4,-1.4])
         {
            translate([x*MountingScrewDistance, y*MountingScrewDistance, -h/2])
               cylinder(d=d, h=h);
         }
      }
}

module Plate(l, h=PlateThickness)
{
   difference()
   {
      translate([0,0,h/2])
         RoundCornersCube([RailLenght, l, h],center=true, r=Rounding);

      MountingDrills();

      // big holes
      for(x=[1,-1])
      {
         w=RailLenght/2-3.0*DistanceHolderWidth+1;
         translate([x*w, 0,0])
            RoundCornersCube([RailLenght/2-2*DistanceHolderWidth, RailDistance-2.5*RailWidth, 3*DrillHeigth],center=true, r=Rounding);
      }
   }
}

module PlateWithExtraDistance()
{
   difference()
   {
      union()
      {
         Plate(l=RailDistance);

         translate([0, 0, ExtraWallDistance/2+PlateThickness])
            MountingDrills(d=10, h=ExtraWallDistance);
      }
      MountingDrills();
   }
}

module Holder()
{
   h=SlotThickness-2*AirGap;
   h2=CaseDistance;
   lenght = ScrewDistanceShort + 2*ScrewToCorner;
   difference()
   {
      union()
      {
         translate([0, RailWidth/2, h/2])
            RoundCornersCube([ScrewDistanceShort, RailWidth-2*AirGap, h],center=true, r=Rounding);

         for(x=[1,-1])
         {
            l=ScrewToCorner;
            translate([x*(lenght/2-l), 0, h2/2]) 
               RoundCornersCube([2*l, 2*l, h2], center=true, r=Rounding);
         }
      }

      // drills
      for(x=[1,-1])
      {
         translate([x*ScrewDistanceShort/2, 0, -DrillHeigth])
            cylinder(d=ScrewDiameter, h=3*DrillHeigth);

         // screw head
         translate([x*ScrewDistanceShort/2, 0, -2])
            cylinder(d=ScrewHeadDiameter, h=CaseDistance);
      }
   }
}

module Futro()
{
   translate([0,0, Heigth/2])
      cube([Width, Lenght, Heigth], center=true);
   
   for(x=[1,-1])
   {
      for(y=[1,-1])
      {
         translate([x*ScrewDistanceShort/2+ScrewOffset, y*ScrewDistanceLong/2, -5])
            cylinder(d=ScrewDiameter, h=Heigth);
      }
   }
}

module Mount()
{
   color("blue")
      Rails();
   color("brown")
      rotate([0,180,0])
         PlateWithExtraDistance();

   color("green")
   {
      translate ([0, -ScrewDistanceLong/2, AirGap])
         Holder();
      translate ([0, +ScrewDistanceLong/2, AirGap])
         rotate([0,0, 180])
            Holder();
   }
   color("gray", 0.4)
   {
      translate ([-ScrewOffset, 0, CaseDistance])
         Futro();
   }
   // a screw head to check whether the room is big enough
   color("black")
   {
      translate ([0, RailDistance/2, SlotThickness+PlateThickness-3])
         cylinder(d=6, h=4);
   }
}

module print(what="holder")
{
   if(what == "holder")
   {
      Holder();
   }
   if(what == "rail")
   {
      rotate([0,180,0])
         Rails();
   }
   if(what == "plate")
   {
      PlateWithExtraDistance();
   }
   if(what == "mount")
   {
      Mount();
   }
   if(what == "futro")
   {
      Futro();
   }
}

print(PrintThis);
