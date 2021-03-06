//

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <math.h>


// #include <pngwriter.h>

#include "peribc.cpp"
#include "writephi.cpp"

using namespace std;
// model parameters as global Variables:
double L=1;
double alpha=1 ;
double beta=1 ;
double gamma=1;
double kappa=2;
double epsilon=5;

double delt=0.2;
double delx;
int peribc();

// ------- main routin --------
int main()
{
  int timesteps=1000;
  int i,j,tn;
  // geometry settings
  int p=25; // phase field numbers
  int scale=1;
  int msize=100*scale; // x axis in pixels
  int nsize=100*scale; // y axis
  delx=2/scale;      // length unit per pixel
  double *phi; //this hold some square of all order parameters for visulaization purposes.
  phi= new double[msize*nsize];
  // number of nucleas at the beginning of simulation
  double nuclein;
  nuclein=msize*nsize/200; // ~5 percent of grid points are nuclei
  nuclein=1;
  // creating boxes array containing order parameters in the box class
  box boxes[nuclein];
  bool activebox[nuclein];
  
  //setting initial condition  (nuclei of grains)
  int nn,ii,jj,pp;
  double irand,jrand,prand;
  for (nn=0;nn<nuclein;nn++)
  {
    irand=rand();
    jrand=rand();
    prand=rand();
    ii=int((nboxsize*irand)/RAND_MAX);
    jj=int((mboxsize*jrand)/RAND_MAX);
    boxes[nn].nucleate(ii,jj,nucboxsize);
  }
//dynamics
  
  int size=mboxsize*nboxsize;
  int jn, pn;
  double del2[p];
  for (tn=1;tn<timesteps;tn++)
  {
    for (pn=0,pn<nuclein,pn++){
      if (activebox[pn]==true){
        boxes[pn].doatimestep;
      }
    }
    if  (tn % 10 ==0){
      for (pn=0,pn<nuclein,pn++){
        if (activebox[pn]==true){
          boxes[pn].adapt;
          if (boxes[pn].isempty()==ture){activebox[pn]=false;}
        }
      }
    }
    // making the phi array
    double* phiii;
    int mboxsizei, nboxsizei;
    for (pn=0,pn<nuclein,pn++){
      mboxsizei=box.mboxsize;
      nboxsize=box.nboxsize;
      phii=new double[mboxsizei*nboxsizei];
    }
    cout << tn << "\n";
  }
  return 0;
}
