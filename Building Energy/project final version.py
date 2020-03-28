import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder,LabelEncoder
from sklearn.model_selection import train_test_split, GridSearchCV

data= pd.read_csv('LLW_joined_weather_train_building.csv')  

data1=data
data1=data1.drop(columns=["Unnamed: 0",'floor_count','building_id','site_id'])

#Finding and Managing Missing Values
data1[data1.isnull().values==True]
data1['wind_direction'].value_counts()

data2=data1

from sklearn import preprocessing


data2['years_of_built']=2016-data2['year_built']
data2=data2.drop(columns=['year_built'])
data2.columns


data2['timestamp'] = data2['timestamp'].astype('category')
data2['timestamp'] = data2['timestamp'].cat.codes


numeric_features = ['meter_reading', 'timestamp','air_temperature', 'cloud_coverage', 'dew_temperature','precip_depth_1_hr', 'sea_level_pressure', 'wind_direction','wind_speed', 'square_feet', 'years_of_built',]
numeric_transformer = Pipeline(steps=[
    ('scaler', StandardScaler())])

categorical_features_1 = ['primary_use']
categorical_transformer_1 = Pipeline(steps=[
    ('onehot', OneHotEncoder(handle_unknown='ignore'))])

preprocessor = ColumnTransformer(
    transformers=[
        ('num', numeric_transformer, numeric_features),
        ('cat1', categorical_transformer_1, categorical_features_1)])

preparedata = Pipeline(steps=[('preprocessor', preprocessor)])
pdata=preparedata.fit_transform(data2)


pdata=pd.DataFrame(pdata)
pdata.to_csv("Clean dataset.csv",sep=',',index=False)


##############################################################

pdata1=pd.read_csv("Clean dataset.csv")
  
y = pdata1.iloc[:,0]
X = pdata1.iloc[:,1:]


np.random.seed(0)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25)


#=============================================================================
# SVR
#=============================================================================
from sklearn.svm import SVR
import time

linear_svr_start = time.time()

linear_svr = SVR(kernel='linear')
linear_svr.fit(X_train, y_train)
linear_svr_y_predict = linear_svr.predict(X_test)
linear_svr_run_time = time.time()-linear_svr_start
print(linear_svr_run_time) #110.59923815727234
len(linear_svr.coef_[0])


 
poly_svr_start = time.time()

poly_svr = SVR(kernel='poly',gamma='auto')
poly_svr.fit(X_train, y_train)
poly_svr_y_predict = poly_svr.predict(X_test)

poly_svr_run_time = time.time()-poly_svr_start
print(poly_svr_run_time) #37.583149671554565

 
rbf_svr_start = time.time()

rbf_svr = SVR(kernel='rbf',gamma='auto')
rbf_svr.fit(X_train, y_train)
rbf_svr_y_predict = rbf_svr.predict(X_test)

rbf_svr_run_time = time.time()-rbf_svr_start
print(rbf_svr_run_time) #37.46214270591736


from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error
print ('R-squared value of linear SVR is', linear_svr.score(X_test, y_test))
print ('R-squared value of Poly SVR is', poly_svr.score(X_test, y_test))
print ('R-squared value of RBF SVR is', rbf_svr.score(X_test, y_test))


print ('Mean squared error of linear SVR is', mean_squared_error(y_test,linear_svr_y_predict))
print ('Mean squared error of Poly SVR is', mean_squared_error(y_test,poly_svr_y_predict))
print ('Mean squared error of RBF SVR is', mean_squared_error(y_test,rbf_svr_y_predict))

### result 
#R-squared value of linear SVR is 0.36504040140586713
#R-squared value of Poly SVR is 0.5446666192715073
#R-squared value of RBF SVR is 0.6779521757907393

#Mean squared error of linear SVR is 0.6286627677095358
#Mean squared error of Poly SVR is 0.45081788509553056
#Mean squared error of RBF SVR is 0.3188541081204133


# plotting
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
pca = PCA(n_components = 1)   
pca.fit(X_test)   
pca_X_test = pca.transform(X_test)


fig, (ax1, ax2,ax3) = plt.subplots(3, sharex=True,figsize=(10,10))
fig.suptitle('2D Plot of SVR predition',size=20)

ax1.scatter(pca_X_test, y_test,  color='black',alpha=0.3,label='true y')
ax1.scatter(pca_X_test,linear_svr_y_predict, color='red',alpha=0.2,label='linear SVR predicted y')
ax1.legend(loc='upper right')
ax1.set_ylabel("meter reading")
#plt.xticks(())
#plt.yticks(())
#plt.show()


#plt.figure() 
ax2.scatter(pca_X_test, y_test,  color='black',alpha=0.3,label='true y')
ax2.scatter(pca_X_test, poly_svr_y_predict, color='green',alpha=0.2,label='poly SVR predicted y')
ax2.legend(loc='upper right')
ax2.set_ylabel("meter reading")
#plt.xticks(())
#plt.yticks(())
#plt.show()


#plt.figure() 
ax3.scatter(pca_X_test, y_test,  color='black',alpha=0.3,label='true y')
ax3.scatter(pca_X_test, rbf_svr_y_predict, color='blue',alpha=0.2,label='rbf SVR predicted y')
ax3.legend(loc='upper right')
ax3.set_ylabel("meter reading")
#plt.xticks(())
#plt.yticks(())

plt.show()


#=============================================================================
# Linear regression
#=============================================================================

# method one   
'''
In this case, sklearn package return better result.
'''

import time
reg_start = time.time()

regressor = LinearRegression()  
regressor.fit(X_train, y_train)
reg_y_pred = regressor.predict(X_test)
regressor.score(X_test, y_test) #R-squared: 0.45050589841888045

reg_run_time = time.time()-reg_start
print(reg_run_time)
#0.018001079559326172



# method two
import statsmodels.api as sm

ols_start = time.time()

mod = sm.OLS(y_train, X_train)
res = mod.fit()
ols_y_predict=res.predict(X_test)
print(res.summary())

ols_run_time = time.time()-ols_start
print(ols_run_time)
#R-squared: 0.435
#0.05300307273864746



print ('Mean squared error of linear Reg-method 1 is', mean_squared_error(y_test,reg_y_pred))
print ('Mean squared error of linear Reg-method 2 is', mean_squared_error(y_test,ols_y_predict))
#Mean squared error of linear Reg-method 1 is 0.5440448234894096
#Mean squared error of linear Reg-method 2 is 0.5440448234894096


# =============================================================================
# Lasso regression
# =============================================================================


from sklearn.linear_model import Lasso,LassoCV,LassoLarsCV  

#lasso = Lasso(alpha=0.01)  
lasso_start = time.time()

lasso = LassoCV() 
# lasso = LassoLarsCV() 
lasso.fit(X_train, y_train)  
print('optimal alpha：',lasso.alpha_) 
#optimal alpha： 0.0004055687476937458
lasso_y_predict = lasso.predict(X_test)

lasso_run_time = time.time()-lasso_start
print(lasso_run_time)
#0.45102596282958984



from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error
print ('R-squared value of lasso is', lasso.score(X_test, y_test))
print ('Mean squared error of linear SVR is', mean_squared_error(y_test,lasso_y_predict))

#with timestamp
#R-squared value of lasso is 0.4505462507872278
#Mean squared error of linear SVR is 0.5440048712914666

# plot of lasso
from sklearn import linear_model
alphas_lasso, coefs_lasso, _ = linear_model.lasso_path(X_train, y_train,  fit_intercept=False)
# Display results
plt.figure(figsize = (12,8))
#neg_log_alphas_lasso = -np.log10(alphas_lasso)
m,n = X_train.shape
for i in range(n):
    plt.plot(alphas_lasso, coefs_lasso[i])
plt.xscale('log')
plt.vlines(lasso.alpha_,ymin=1,ymax=-8)
plt.xlabel('$\\lambda$')
plt.ylabel('coefficients')
plt.title('Lasso paths - Sklearn')
plt.legend()
plt.axis('tight')
plt.show()



# =============================================================================
# comparsion
# =============================================================================

plt.figure(figsize = (12,8))
box = plt.boxplot(pd.DataFrame([y_test-reg_y_pred,
                      y_test-rbf_svr_y_predict,
                      y_test-lasso_y_predict]),patch_artist=True)
colors = ['lightblue',  'pink', 'lightgreen']
for patch, color in zip(box['boxes'], colors):
    patch.set_facecolor(color)
plt.title('Boxplot of Residuals')
plt.xticks((1,2,3),('Linear Regression','SVR','LASSO'))
plt.xlabel('Model types')
plt.ylabel('Residual')
plt.show()





