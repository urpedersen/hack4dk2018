import processing.dxf.*;

int offset;

Table alleByerDK, koordinaterKBH, movings;
Table midiExport;
int data4midi[];
Table midiExportMonthly;
int data4midiMonthly[];
PFont f;
int month0, year0, daysPrMonth;
int day, year, month, dayNumber;
int numberOfYears, starty, endy, ydiff;//timeline
int[][] colors;
int numberOfFrames;

void setup() 
{
  background(1);
  
  //size(1280, 900);
  size(1920, 1080);

  //simulation start
  year0 = 1890;
  month0 = 1;
  daysPrMonth = 30;
  
  numberOfFrames = (1923-year0)*12*30;
  //numberOfFrames = 360*3;
  
  alleByerDK = loadTable("world_cities_dk.csv");
  koordinaterKBH = loadTable("kbh_koordinater.csv");
  movings = loadTable("moving9.csv");
  
  midiExport = new Table();
  midiExport.addColumn("daynumber");
  midiExport.addColumn("hovedstaden");
  midiExport.addColumn("jylland");
  midiExport.addColumn("fyn");
  midiExport.addColumn("sjælland");
  midiExport.addColumn("bornholm"); 
  
  midiExportMonthly = new Table();
  midiExportMonthly.addColumn("daynumber");
  midiExportMonthly.addColumn("hovedstaden");
  midiExportMonthly.addColumn("jylland");
  midiExportMonthly.addColumn("fyn");
  midiExportMonthly.addColumn("sjælland");
  midiExportMonthly.addColumn("bornholm"); 
  
  f = createFont("Courier-Bold", 44);
  textFont(f);
  textAlign(CENTER, CENTER);

  colorMode(HSB, 100);
}

void draw() 
{
  background(1);
  //fill(1,50);
  //rect(0,0,width,height);
    
  day = frameCount % daysPrMonth +1;
  month = (month0-1 + frameCount/daysPrMonth) % 12 +1;
  year = year0 + frameCount / (12*daysPrMonth);
  dayNumber = date2dayNumber(year, month, day);
  println("year:" + year + " month:" + month + " day" + day + " dayNumber" + date2dayNumber(year, month, day));
  //println("frameCount:"+frameCount);
  
  data4midi = new int[5];
  if (frameCount == 1 || day == 1)
  {
    data4midiMonthly = new int[5];
    for(int i=0;i<data4midiMonthly.length;i++)
      data4midiMonthly[i]=0;
  }
  
  noStroke();
  fill(49,20,37);

  // Tweeks
  float xRatioDK = 742./4500.;
  float yRatioDK = 846./4800.;
  float xRatioCPH = 4250./900.;
  float yRatioCPH = 4350./1200.;
  
  //DANMARKS BYER
  for (int i=1 ; i<alleByerDK.getRowCount() ; i++ ) 
  {
    float x = (alleByerDK.getFloat(i,6) - 8) * xRatioDK * height;
    float y = (57.8-alleByerDK.getFloat(i,5))* yRatioDK  * width;
    
    int omraade = geoCoordinates2AreaCode(alleByerDK.getFloat(i,6),alleByerDK.getFloat(i,5));
    //println(omraade);
    
    setColor(omraade,40);
        
    ellipse(x, y, 4, 4);
  } 

  //KBH FORSTØRRET
  fill(40,44,35);
  for (int i=1 ; i<25000 ; i++ ) // alleByerDK.getRowCount()
  {
    float x = (koordinaterKBH.getFloat(i,7) - 12.28) * xRatioCPH * height;
    float y = (55.74-koordinaterKBH.getFloat(i,6))* yRatioCPH  * width;   
    ellipse(x,y, 2, 2);
  }
  
  //KBH på dk-kortet
  fill(40,40,40);
  //print();
  for (int i=1 ; i<1000 ; i++ ) 
  {
    float x = (koordinaterKBH.getFloat(i,7) - 8) * xRatioDK * height;
    float y = (57.8-koordinaterKBH.getFloat(i,6))* yRatioDK  * width;   
    ellipse(x, y, 3, 3);
  }
      
  //movings
  for (int i=1 ; i<movings.getRowCount(); i++ ) // 
  //for (int i=1 ; i<1000; i++ )
  {
    //find personens flyttedato
    int dag_p = movings.getInt(i,6);
    int maaned_p = movings.getInt(i,7); 
    int aar_p = movings.getInt(i,8); 
    int persons_flyttedato = date2dayNumber(aar_p, maaned_p, dag_p);
    
    //STARTING POINT
    if (persons_flyttedato <= dayNumber + 2*daysPrMonth && persons_flyttedato >= dayNumber - daysPrMonth) 
    {
      //println("year_p:" + aar_p + " month_p:" + maaned_p + " day_p" + dag_p + " persons_flyttedato" + date2dayNumber(aar_p, maaned_p, dag_p) + " dayNumber" + date2dayNumber(year, month, day));

      float x_start = (movings.getFloat(i,13) - 8) * xRatioDK * height;
      float y_start = (57.8-movings.getFloat(i,12))* yRatioDK  * width;   
      int omraade = geoCoordinates2AreaCode(movings.getFloat(i,13),movings.getFloat(i,12));
      
      // Ready 2 Go - grow bubble in homeCity
      if (persons_flyttedato <= dayNumber + 2*daysPrMonth && persons_flyttedato > dayNumber + daysPrMonth)
      {
      setColor(omraade,(2*daysPrMonth-(abs(persons_flyttedato-dayNumber-2*daysPrMonth))*1.5));
      //println("flyt_dato: "+ persons_flyttedato + "daynumber: "+ dayNumber);
       
      ellipse(x_start, y_start, (2*daysPrMonth-abs(persons_flyttedato-dayNumber))*2/3, (2*daysPrMonth-abs(persons_flyttedato-dayNumber))*2/3);
      }
   
      // FLYTTE PRIK
      if (persons_flyttedato <= dayNumber + daysPrMonth && persons_flyttedato > dayNumber )
      {
        //ENDING POINT FORSTØRRET
        float x_slut_forst = (movings.getFloat(i,10) - 12.28) * xRatioCPH * height;
        float y_slut_forst = (55.74-movings.getFloat(i,9))* yRatioCPH  * width;
        
        //MOVING POINT
        float x = map(dayNumber, persons_flyttedato-daysPrMonth, persons_flyttedato, x_start, x_slut_forst);
        float y = map(dayNumber, persons_flyttedato-daysPrMonth, persons_flyttedato, y_start, y_slut_forst);
        float x_old = map(dayNumber-1, persons_flyttedato-daysPrMonth, persons_flyttedato, x_start, x_slut_forst);
        float y_old = map(dayNumber-1, persons_flyttedato-daysPrMonth, persons_flyttedato, y_start, y_slut_forst);
        
        setColor(omraade,0);
        noStroke();
        /*int numpoint=10;
        for(int k=0;k<numpoint;k++){
          float xdraw = map(k,0,numpoint,x,x_old);
          float ydraw = map(k,0,numpoint,y,y_old);
          ellipse(xdraw, ydraw, 20, 20);
        }*/
        ellipse(x, y, 20, 20);
      }
      
      // Ankomst og fade
      if (persons_flyttedato <= dayNumber && persons_flyttedato > dayNumber - daysPrMonth)
      {
        setColor(omraade,(dayNumber-persons_flyttedato)*3.33);
        //println("flyt_dato: "+ persons_flyttedato + "daynumber: "+ dayNumber);
    
        //ENDING POINT FORSTØRRET
        float x_slut_forst = (movings.getFloat(i,10) - 12.28) * xRatioCPH * height;
        float y_slut_forst = (55.74-movings.getFloat(i,9))* yRatioCPH  * width;
        
        ellipse(x_slut_forst, y_slut_forst, 20, 20);
      }
      
      //Ankomst midi
      if (persons_flyttedato-30 == dayNumber)
      {
        data4midi[omraade]++;
        //print(data4midiMonthly);
        data4midiMonthly[omraade] = data4midiMonthly[omraade] + 1;
      }
    }
  }
  
  TableRow newRow = midiExport.addRow();
  newRow.setInt("daynumber", dayNumber);
  newRow.setInt("hovedstaden", data4midi[0]);
  newRow.setInt("jylland", data4midi[1]);
  newRow.setInt("fyn", data4midi[2]);
  newRow.setInt("sjælland", data4midi[3]);
  newRow.setInt("bornholm", data4midi[4]);
  
  if (day == 30)
  {
    TableRow newRowMonthly = midiExportMonthly.addRow();
    newRowMonthly.setInt("daynumber", dayNumber);
    newRowMonthly.setInt("hovedstaden", data4midiMonthly[0]);
    newRowMonthly.setInt("jylland", data4midiMonthly[1]);
    newRowMonthly.setInt("fyn", data4midiMonthly[2]);
    newRowMonthly.setInt("sjælland", data4midiMonthly[3]);
    newRowMonthly.setInt("bornholm", data4midiMonthly[4]);
  }
   
  //Forstørrelsesglas
  noFill();
  stroke(#838a86);
  ellipse(1454,399,900,900);
  ellipse(815,722,40,40);
  line(806,739,1378,843);
  line(1059,183,794,713);
  
  // CALENDAR
  textFont(f);
  //rect(55,80,140,105);
  fill(#838a86);
  //text(day,125,100
  text("" + day + ". " + maaned(month),130,60);
  text(year,130,120);
  
  String filename = "./film/"+nf(frameCount,4)+".png";
  //println(filename);
  saveFrame(filename);
  if (frameCount > numberOfFrames-1) 
  {
    saveTable(midiExport, "data/midiExportData.csv");
    saveTable(midiExportMonthly, "data/midiExportDataMonthly.csv");
    //print(midiExport);
    exit();
  }
}
  
int date2dayNumber(int year, int month, int day)
{
  return ( (year-year0)*12*daysPrMonth + (month-1)*daysPrMonth + day);
}

int geoCoordinates2AreaCode(float lon, float lat)
{
if(lon < 11.5 && lat > 56.2) {return 1;} // jylland
if(lon < 10.75 && lat > 55.65) {return 1;} // jylland
if(lon < 9.8 && lat > 54.8) {return 1;} // jylland
if(lon < 10.05 && lat < 55.1) {return 1;} // jylland

if(lon > 9.8 && lon < 11 && lat < 55.65) {return 2;} // fyn

if(lon > 11 && lon < 12.8 && lat < 55.4) {return 3;} // sjælland
if(lon > 10.5 && lon < 12.2 && lat < 56.5) {return 3;} // sjælland
if(lon > 11.6 && lon < 12.2 && lat < 55.7) {return 3;} // sjælland
if(lon > 12 && lon < 12.3 && lat < 55.6) {return 3;} // sjælland

if(lon > 14 && lon < 16 && lat > 54 && lat < 56) {return 4;} // bornholm

return 0;
}

int setColor(int omraade, float fade)
{ 
  if (omraade == 0){fill(85,80,58,100-fade);};//hovedstadsområdet
  if (omraade == 1){fill(11,97,72,100-fade);};//jylland
  if (omraade == 2){fill(54,62,54,100-fade);};//fyn
  if (omraade == 3){fill(63,67,63,100-fade);};//sjælland
  if (omraade == 4){fill(36,66,76.100-fade);};//bornholm
  
  return 42;
}

String maaned(int month)
{
if(month ==1) {return "jan.";}
if(month ==2) {return "feb.";}
if(month ==3) {return "mar.";}
if(month ==4) {return "apr.";}
if(month ==5) {return "maj";}
if(month ==6) {return "jun.";}
if(month ==7) {return "jul.";}
if(month ==8) {return "aug.";}
if(month ==9) {return "sep.";}
if(month ==10) {return "okt.";}
if(month ==11) {return "nov.";}
return "dec.";
}
