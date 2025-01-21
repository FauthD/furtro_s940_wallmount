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
CaseDistance = 9;

RailWidth = 15;
RailHeigth = 5.0;

DistanceHolderWidth = 12;

PlateThickness = 2.2;

AirGap = 0.3;

/* [Futro] */
Lenght = 250;
Width  = 185;
Heigth = 52;

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

      // // slot
      // for(y=[1,-1])
      // {
      //    translate([0, y*(RailDistance/2+SlotWidth/2), SlotThickness/2])
      //       #cube([RailLenght+Epsilon, SlotWidth+AirGap, SlotThickness+Epsilon], center=true);
      // }
      MountingDrills();
   }
}

module MountingDrills()
{
      for(x=[0,1,-1])
      {
         for(y=[0,1,2,-1, -2])
         {
            translate([x*MountingScrewDistance, y*MountingScrewDistance, -RailHeigth])
               cylinder(d=MountingScrewDiameter, h=3*RailHeigth+ExtraWallDistance);
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
         w=RailLenght/2-3.0*DistanceHolderWidth;
         translate([x*w, 0,0])
            RoundCornersCube([RailLenght/2-2*DistanceHolderWidth, RailDistance-2.5*RailWidth, 3*RailHeigth],center=true, r=Rounding);
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

         for(x=[0,1,-1])
         {
            for(y=[0,1,2,-1, -2])
            {
               translate([x*MountingScrewDistance, y*MountingScrewDistance, 0])
                  cylinder(d=10, h=ExtraWallDistance);
            }
         }
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
            RoundCornersCube([ScrewDistanceShort, RailWidth-AirGap, h],center=true, r=Rounding);

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
         translate([x*ScrewDistanceShort/2, 0, -RailHeigth])
            cylinder(d=ScrewDiameter, h=3*RailHeigth);

         // screw head
         translate([x*ScrewDistanceShort/2, 0, -2])
            cylinder(d=ScrewHeadDiameter, h=CaseDistance);
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
      PlateWithExtraDistance();
   }
   if(what == "mount")
   {
      Mount();
   }
}

print(PrintThis);
