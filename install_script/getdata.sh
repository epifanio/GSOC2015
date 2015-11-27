#!/usr/bin/env bash
USERHOME=/home/main

DATA_FOLDER=$USERHOME/notebooks/data
GRASS_DATA_FOLDER=$DATA_FOLDER/grass7data/north_carolina
BASE_URL="http://grass.osgeo.org/sampledata/north_carolina"
NE2_DATA_FOLDER="$DATA_FOLDER/natural_earth2"

mkdir -p $DATA_FOLDER
mkdir -p $GRASS_DATA_FOLDER
mkdir -p $NE2_DATA_FOLDER

FILES="shape rast_geotiff kml"

for FILE in $FILES ; do
   wget -N --progress=dot:mega "$BASE_URL/nc_$FILE.tar.gz"
done

wget -N http://www.grassbook.org/grasslocations/nc_epsg_codes.html
wget -N http://grass.osgeo.org/sampledata/north_carolina/README.html

mv nc_epsg_codes.html $DATA_FOLDER/
mv README.html $DATA_FOLDER/

#and install them ...
#cd "$GRASS_DATA_FOLDER"

for FILE in $FILES ; do
    if [[ "$FILE" != rast_geotiff ]]
        then
            tar xzf "nc_$FILE.tar.gz"
            chgrp users "$FILE"
            chmod g+w "$FILE"
			mv "nc$FILE/" $GRASS_DATA_FOLDER/
    fi
    if [[ "$FILE" == rast_geotiff ]]
        then
		    tar xzf "nc_$FILE.tar.gz"
	        mv "ncrast" $GRASS_DATA_FOLDER/
    fi
done


wget "http://grass.osgeo.org/sampledata/north_carolina/nc_basic_spm_grass7.tar.gz"
tar -zxvf nc_basic_spm_grass7.tar.gz
rm -rf nc_basic_spm_grass7.tar.gz
mv nc_basic_spm_grass7 $DATA_FOLDER/grass7data



wget -c --progress=dot:mega http://download.osgeo.org/livedvd/data/natural_earth2/all_10m_20.tgz
tar xzf all_10m_20.tgz
for tDir in ne_10m_*; do
   mv $tDir/* $NE2_DATA_FOLDER
   rm -rf $tDir
done


RFILE=HYP_50M_SR_W_reduced.zip
wget -c --progress=dot:mega \
   "http://download.osgeo.org/livedvd/data/natural_earth2/$RFILE"
unzip "$RFILE"

rm "$RFILE"

mv HYP_* "$NE2_DATA_FOLDER"

cd "$NE2_DATA_FOLDER"

for SHP in *.shp; do \
    S=`basename $SHP .shp`
    ogrinfo -sql "CREATE SPATIAL INDEX ON $S" $SHP;
done

rm -rf /home/main/*gz

mkdir -p /home/main/.grass7/
touch /home/main/.grass7/rc

echo "GISDBASE: /home/main/notebooks/data/grass7data" >> /home/main/.grass7/rc
echo "LOCATION_NAME: nc_basic_spm_grass7" >> /home/main/.grass7/rc
echo "MAPSET: PERMANENT" >> /home/main/.grass7/rc
echo "LOCATION: /home/main/notebooks/data/grass7data/nc_basic_spm_grass7" >> /home/main/.grass7/rc


##################################
# Download netCDF datasets:
#

mkdir -p  /home/main/notebooks/data/netcdf
mkdir netcdf; cd netcdf

t_netcdf_files="
README_netCDF_samples.txt
rx5dayETCCDI_yr_MIROC5_historical_r2i1p1_1850-2012.nc
rx5dayETCCDI_yr_MIROC5_historical_r2i1p1_1850-2012.nc.txt
rx5dayETCCDI_yr_MIROC5_rcp45_r2i1p1_2006-2100.nc
rx5dayETCCDI_yr_MIROC5_rcp45_r2i1p1_2006-2100.nc.txt
txxETCCDI_yr_MIROC5_historical_r2i1p1_1850-2012.nc
txxETCCDI_yr_MIROC5_historical_r2i1p1_1850-2012.nc.txt
txxETCCDI_yr_MIROC5_rcp45_r2i1p1_2006-2100.nc
txxETCCDI_yr_MIROC5_rcp45_r2i1p1_2006-2100.nc.txt
"
for n in $t_netcdf_files; do
	wget -c -N --progress=dot:mega http://download.osgeo.org/livedvd/data/netcdf/$n
done

mv * /home/main/notebooks/data/netcdf/
cd ..
rm -rf netcdf

# Cape Cod SRTM and LANDSAT  (this part is disble because of disc space issue)

mkdir -p $DATA_FOLDER/landsat/
DATA_URL="http://download.osgeo.org/livedvd/data/ossim/"
BASENAME="p011r031_7t19990918_z19_nn"
for BAND in 10 20 30 ; do
    # LANDSAT
    wget --progress=dot:mega "$DATA_URL/ossim_data/${BASENAME}$BAND.tif" \
         --output-document="$DATA_FOLDER/landsat/${BASENAME}$BAND.tif"
done
wget --progress=dot:mega "$DATA_URL/ossim_data/p011r031_7t19990918_z19_nn80.tif" \
         --output-document="$DATA_FOLDER/landsat/p011r031_7t19990918_z19_nn80.tif"

wget --progress=dot:mega "$DATA_URL/ossim_data/SRTM_fB03_p011r031.tif" \
         --output-document="$DATA_FOLDER/landsat/SRTM_fB03_p011r031.tif"

wget  --progress=dot:mega "http://download.osgeo.org/livedvd/data/ossim/ossim_data/ossim-dem-color-table-template.kwl" \
         --output-document="$DATA_FOLDER/landsat/ossim-dem-color-table-template.kwl"