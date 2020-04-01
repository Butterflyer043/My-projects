################
## Data Frame ##
################
### 1. create a  data frame
df <- data.frame(name=c("John","Sally","Fred"),gender=c('M','F','M'),age=c(23,45,67))
df
df_name <- df[df$name] # create a new data frame
class( df_name)
df_age <- df$age # create a new list with the type of each variable
class(df_age)
### 2. access elements in dataframe
df[c(1,2),c(2,3)] #access row 1&2, col 2&3
df[2,2]  #access row 2, col 2
df$age [1]  #access an element in a col
### 3. names
names(df) 
colnames(df)[1] <- 'NAME' # 更改其中一列的名字
rownames(df) #默认123
#name the rows
rownames(df) <- c('one','two','three')  #更改默认排的名字
rownames(df)
df
### 4. add rows or columns dataframes
df$height <- c(67,69,60) # add column 'height'
df
#rbind: bine by rows
df_1 <- data.frame(name=c("Harry","Alana"),gender=c('M','F'),age=c(45,16),height=c(67,61))
rownames(df_1) <- c('four','five')
df_bigger <- rbind(df,df_1) # add new rows 
df_bigger
#cbind: bine by col
df_2 <- data.frame(weight=c(126,123,98,107,111),rank=c(1,2,2,1,1))
df_bigger <- cbind(df_bigger,df_2) #add column 'row'
df_bigger
#merge: merge two dataframes BY=
df_bigger$ID <- c(11,22,33,44,55) # add col
df_3 <- data.frame(ID=c(11,22,33,44,55), grade=c(90,78,99,71,94))
df_bigger<- merge(df_bigger,df_3,by='ID') #add column 'grade'
df_bigger
### 5. remove rows or columns dataframes
df_smaller <- df_bigger
df_smaller$weight <-  NULL # remove column'weight'
df_smaller
#subset: remove col
df_smaller <- subset(df_smaller,select = -grade)
df_smaller
#remove rows
df_smaller <- df_smaller[df_smaller$age>25,] #注意逗号！
df_smaller

##formatC is from C code formatting - creates a 5 digit int
CancerRates$GEOID <- formatC(CancerRates$GEOID, width = 5, format = "d", flag = "0")
head(CancerRates)
CancerRatesB$GEOID <- formatC(CancerRatesB$GEOID, width = 5, format = "d", flag = "0")
head(CancerRatesB)
# x - 为向量输入
# digits - 是显示总位数
# nsmall - 是最小位数的小数点右边
# scientific - 设置为TRUE，则显示科学记数法
# width - 指示要通过填充空白在开始时显示的最小宽度
# justify - 是字符串显示在左边，右边或中心
# format - d for integer 
##Remove the (...) from the state values
#gsub("目标字符", "替换字符", 对象)
#http://www.endmemo.com/program/R/gsub.php 字符替换具体含义
#https://blog.csdn.net/u011596455/article/details/79600579 字符串 stringer 包
CancerRates[] <- lapply(CancerRates, function(x) gsub("\\s*\\([^\\)]+\\)", "", x))
head(CancerRates)
CancerRatesB[] <- lapply(CancerRatesB, function(x) gsub("\\s*\\([^\\)]+\\)", "", x))
head(CancerRatesB)



### 6. binning dataframes
sel_col <- c(2,4:5)
df <- df_bigger[sel_col] # 精简数据，选取有用列
df
#ifelset(条件,是则：,否则：)
df$tall <- ifelse(df$height>65,'T','F')
df
#cut(data,break=c()数据分段点,label=c()) 若标签为n个，分段点需要n+1个
#break = (-Inf,12,20,46,Inf)  为 （小于等于11，12-20，21-46，大于等于47）
df$agebin <- cut(df$age,breaks=c(-Inf,20,40,60,Inf),labels=c("child","young","middle","old"))
df
### 7. sorting dataframe
df <- df[order(df$age),] #注意逗号！
df
### 8. dealing with missing or NA
df_4 <- data.frame(name=c('','Alana','Joe'),gender=c('M','F','M'),age=c(45,16,34))
df_4
complete.cases(df_4) #如果导入的空白值为'', 则需要把'' 换成NA 在进行剔除
df_4$name <- replace(df_4$name,df_4$name=='',NA)
df_4
df_4 <- df_4[complete.cases(df_4),] #注意逗号！
df_4
#  方法2：ddata<-ddata[ ! ddata$gender%in% c("NA", "<NA>", NA, "na"), ]

#################
## apply family##
#################
###apply（x,margin,fun）#####
APdf=data.frame(x=c(1,2,3,4,5), y=c(10,20,30,40,50), z=c(100,200,300,400,500))
APdf
#apply(data,边:row=1按行计算/col=2/c(1,2),FUN需要应用的function)
###当函数只有一个值，(函数输入方式有三种，均可行)
apply(APdf, 1, function(x) sum(x)) # 求所有行之和
rowSums(APdf) # 同上
APfun_1 <- function(x){x^2}
apply(APdf[c(1,4),], 1, FUN=APfun_1) #求1、4俩行每行每个数的平方
apply(APdf[c(1,4),], 2, FUN=APfun_1) #求1、4俩行所有列每个数的平方
apply(APdf[c(1,4),], 1, FUN=sum) # 求1、4俩行每行之和 
apply(APdf[c(1,4),], 2, FUN=sum) # 求1、4俩行每列之和 
APdf
apply(APdf, 2, sum) # 求所有列之和
apply(APdf[,c('x','z')], 1, APfun_1)# 求xz俩列每行所有数的平方
apply(APdf[,c('x','z')], 2, APfun_1) # 求xz俩列每列所有数的平方
apply(APdf[,c('x','z')], 1, sum)# 求xz俩列每行之和
apply(APdf[,c('x','z')], 2, sum)# 求xz俩列每列之和

###当函数中含有俩个值
APdf
APfun_2 <- function(a,b){a*b} 
apply(APdf, 1,function(x) APfun_2(x[1],x[3])) #每行第一个数*第三个数
apply(APdf, 2,function(x) APfun_2(x[1],x[3])) #每行第一个数*第三个数
apply(APdf[c(1,4),], 1, function(x) APfun_2(x[1],x[3])) #1、4两行每行第一个数*第三个数
apply(APdf[c(1,4),], 2, function(x) APfun_2(x[1],x[3])) #1、4两行每列第一个数*第三个数
apply(APdf[,c('x','z')], 1, function(x) APfun_2(x[1],x[2]))# 求xz俩列每行第一个数*第二个
apply(APdf[,c('x','z')], 2, function(x) APfun_2(x[1],x[2]))# 求xz俩列每列第一个数*第二个

###Error
APdf 
#1.dim(x) must have a positive length 
#dim(x) 查看维度 --> 排 列，eg,dim(APdf)-->5 3,  dim(df)-->5 5,  dim(df_bigger)-->5 8
#dim(df[,2])-->NULL,  dim(df[2,])-->5 1,  dim(df[2])-->5 1, dim(df[,2:3])-->5 2, 
apply(df[,2],2,sum) # ERROR 因为df[,2] 是 a dimensionless vector 则应改为
apply(df[,2:3],2,sum) #使用俩列改变dim
apply(df[drop=F,2],2,sum) #增加一列 或者用lappy() 详见下
#2.'type'(character)参数不对
apply(df[,1:2],2,sum) # ERROR 因为 df[,1] 是姓名，type 为char，则应改用sapply() 详见下


##### lapply (list, fun, ...) ##### 
#lapply 以每个variable为单位计算，输出为list
is.list(APdf)
APdf
lapply(APdf, function(x) sum(x)) #求每个variable的和
lapply(APdf[2,], function(x) sum(x)) #求第二排中每col的和 
lapply(APdf[1:3,], function(x) sum(x)) #求第1-3排中每col的和 
lapply(APdf[,2], function(x) sum(x)) #当input list变成向量时，输出为list，不计算结果
lapply(APdf[drop=F,2], function(x) sum(x)) #求第2列中每col的和 
lapply(APdf[,2:3], function(x) sum(x)) #求第2-3列中每col的和 

##### sapply (list, fun, ...，simplify) #####
#simplify=T（默认值）：返回值的类型由计算结果定，如果函数返回值长度为1，则sapply将list简化为vector；
#simplify=F：返回值的类型是list，此时与lapply完全相同
sapply(APdf, function(x) sum(x)) # 输出为vector
lapply(APdf[1:3,], function(x) sum(x)) #求第1-3排中每col的和 
sapply(APdf[,2], function(x) sum(x)) #当input list变成向量时，输出为vector，不计算结果
sapply(APdf[drop=F,2], function(x) sum(x))  # 输出为vector

sapply(df,function(x) ifelse(is.numeric(x),sum(x),NA))

##### mapply/tapply ####
#https://blog.csdn.net/u014543416/article/details/79037389





##############
## ggplot 2###
##############


##########
## map ##
#########
library(leaflet)
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles (tile瓷砖瓦片）
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
#add circle
df_mapp = data.frame(Lat = 1:10, Long = rnorm(10))
leaflet() %>% addCircles(data = df_mapp, lat = ~ Lat, lng = ~ Long)%>%  
#LAT = the latitude variable is guessed by looking for columns named lat or latitude (case-insensitive)
#LNG = the longitude variable is guessed by looking for lng, long, or longitude
# setView() sets the center of the map view and the zoom level; about zoom 
#https://wiki.openstreetmap.org/wiki/Zoom_levels
addPolygons(fillColor = ~pal(rate), 
            fillOpacity = 0.8,   # 透明度
            color = "#BDBDC3",  #边框颜色
            weight = 1,    # 边线厚度
            popup = popup_dat, # 导入每一个方块数据
            group="Cancer Rate/100,000 by Counties") %>%   
addMarkers(data=LandUse,lat=~lat, lng=~lng, popup=popup_LU, group = "Land Use Sites")
  addAwesomeMarkers(data=sd,~long, ~lat, icon=icons, label=~as.character(mag))
awesomeIcons(icon = "home", library = "glyphicon",markerColor = "blue",)
  

# fitBounds() fits the view into the rectangle [lng1, lat1] – [lng2, lat2];
# clearBounds() clears the bound, so that the view will be automatically determined 
# by the range of latitude/longitude data in the map layers if provided;