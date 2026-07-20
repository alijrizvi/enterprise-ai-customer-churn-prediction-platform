{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "application/vnd.databricks.v1+cell": {
     "cellMetadata": {
      "byteLimit": 2048000,
      "rowLimit": 10000
     },
     "finishTime": 1783608321850,
     "inputWidgets": {},
     "nuid": "980e471f-41ca-41c0-a7bf-3c9fdcac9104",
     "showTitle": false,
     "startTime": 1783608282102,
     "submitTime": 1783608270116,
     "tableResultSettingsMap": {},
     "title": ""
    }
   },
   "outputs": [],
   "source": [
    "-- DDL\n",
    "-- Customer Transactions Dataset\n",
    "-- Will be Useful for the Customer Churn Predictor\n",
    "\n",
    "CREATE SCHEMA IF NOT EXISTS `enterprise-ai-customer-churn-prediction-platform`;\n",
    "\n",
    "CREATE OR REPLACE VIEW customer_data AS\n",
    "SELECT * \n",
    "FROM `samples`.`bakehouse`.`sales_transactions`;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "application/vnd.databricks.v1+cell": {
     "cellMetadata": {
      "byteLimit": 2048000,
      "rowLimit": 10000
     },
     "finishTime": 1783608676807,
     "inputWidgets": {},
     "nuid": "c74e91f3-8c1c-4399-8529-845b515495c5",
     "showTitle": false,
     "startTime": 1783608674057,
     "submitTime": 1783608673995,
     "tableResultSettingsMap": {},
     "title": ""
    }
   },
   "outputs": [],
   "source": [
    "-- DDL 1\n",
    "-- Reconfiguring the Dataset to our Needs\n",
    "\n",
    "CREATE OR REPLACE VIEW data_by_date AS\n",
    "SELECT LEFT(dateTime, 10) AS Date,\n",
    "  COUNT(DISTINCT(customerID)) AS total_customers,\n",
    "  COUNT(DISTINCT(transactionID)) AS unique_transactions,\n",
    "  COUNT(DISTINCT(product)) AS unique_products_bought,\n",
    "  SUM(quantity) AS total_products_bought,\n",
    "  SUM(totalPrice) AS total_spent\n",
    "FROM customer_data\n",
    "GROUP BY LEFT(dateTime, 10)\n",
    "ORDER BY Date;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "application/vnd.databricks.v1+cell": {
     "cellMetadata": {
      "byteLimit": 2048000,
      "rowLimit": 10000
     },
     "finishTime": 1783608765720,
     "inputWidgets": {},
     "nuid": "68e71e52-1ef5-4851-aa59-a21ebb1033aa",
     "showTitle": false,
     "startTime": 1783608763050,
     "submitTime": 1783608763013,
     "tableResultSettingsMap": {},
     "title": ""
    }
   },
   "outputs": [],
   "source": [
    "-- DDL 2\n",
    "-- Dataset Engineering 2: Customer-Based Data\n",
    "\n",
    "CREATE OR REPLACE VIEW data_by_customer AS\n",
    "SELECT customerID,\n",
    "  COUNT((transactionID)) AS total_purchases,\n",
    "  COUNT(DISTINCT(product)) AS unique_products_bought,\n",
    "  SUM(quantity) AS total_products_bought,\n",
    "  SUM(totalPrice) AS total_spent\n",
    "FROM customer_data\n",
    "GROUP BY customerID\n",
    "ORDER BY customerID;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "application/vnd.databricks.v1+cell": {
     "cellMetadata": {
      "byteLimit": 2048000,
      "rowLimit": 10000
     },
     "finishTime": 1783608773540,
     "inputWidgets": {},
     "nuid": "f07858ed-c6c9-4134-aa9a-82f258f8a72b",
     "showTitle": false,
     "startTime": 1783608769237,
     "submitTime": 1783608769207,
     "tableResultSettingsMap": {},
     "title": ""
    }
   },
   "outputs": [
    {
     "output_type": "display_data",
     "data": {
      "text/html": [
       "<style scoped>\n",
       "  .table-result-container {\n",
       "    max-height: 300px;\n",
       "    overflow: auto;\n",
       "  }\n",
       "  table, th, td {\n",
       "    border: 1px solid black;\n",
       "    border-collapse: collapse;\n",
       "  }\n",
       "  th, td {\n",
       "    padding: 5px;\n",
       "  }\n",
       "  th {\n",
       "    text-align: left;\n",
       "  }\n",
       "</style><div class='table-result-container'><table class='table-result'><thead style='background-color: white'><tr><th>customerID</th><th>total_purchases</th><th>unique_products_bought</th><th>total_products_bought</th><th>total_spent</th></tr></thead><tbody><tr><td>2000000</td><td>9</td><td>4</td><td>67</td><td>201</td></tr><tr><td>2000001</td><td>8</td><td>4</td><td>51</td><td>153</td></tr><tr><td>2000002</td><td>17</td><td>5</td><td>109</td><td>327</td></tr><tr><td>2000003</td><td>13</td><td>5</td><td>72</td><td>216</td></tr><tr><td>2000004</td><td>17</td><td>6</td><td>121</td><td>363</td></tr><tr><td>2000005</td><td>21</td><td>6</td><td>110</td><td>330</td></tr><tr><td>2000006</td><td>18</td><td>5</td><td>160</td><td>480</td></tr><tr><td>2000007</td><td>13</td><td>6</td><td>122</td><td>366</td></tr><tr><td>2000008</td><td>10</td><td>4</td><td>58</td><td>174</td></tr><tr><td>2000009</td><td>9</td><td>5</td><td>52</td><td>156</td></tr><tr><td>2000010</td><td>16</td><td>6</td><td>112</td><td>336</td></tr><tr><td>2000011</td><td>6</td><td>4</td><td>33</td><td>99</td></tr><tr><td>2000012</td><td>9</td><td>3</td><td>74</td><td>222</td></tr><tr><td>2000013</td><td>11</td><td>6</td><td>53</td><td>159</td></tr><tr><td>2000014</td><td>13</td><td>6</td><td>77</td><td>231</td></tr><tr><td>2000015</td><td>12</td><td>6</td><td>67</td><td>201</td></tr><tr><td>2000016</td><td>13</td><td>5</td><td>69</td><td>207</td></tr><tr><td>2000017</td><td>12</td><td>4</td><td>56</td><td>168</td></tr><tr><td>2000018</td><td>11</td><td>5</td><td>44</td><td>132</td></tr><tr><td>2000019</td><td>19</td><td>6</td><td>106</td><td>318</td></tr><tr><td>2000020</td><td>13</td><td>5</td><td>59</td><td>177</td></tr><tr><td>2000021</td><td>18</td><td>6</td><td>100</td><td>300</td></tr><tr><td>2000022</td><td>18</td><td>6</td><td>137</td><td>411</td></tr><tr><td>2000023</td><td>14</td><td>5</td><td>130</td><td>390</td></tr><tr><td>2000024</td><td>9</td><td>5</td><td>48</td><td>144</td></tr><tr><td>2000025</td><td>11</td><td>6</td><td>52</td><td>156</td></tr><tr><td>2000026</td><td>10</td><td>5</td><td>70</td><td>210</td></tr><tr><td>2000027</td><td>8</td><td>5</td><td>41</td><td>123</td></tr><tr><td>2000028</td><td>9</td><td>5</td><td>68</td><td>204</td></tr><tr><td>2000029</td><td>22</td><td>6</td><td>138</td><td>414</td></tr><tr><td>2000030</td><td>16</td><td>6</td><td>107</td><td>321</td></tr><tr><td>2000031</td><td>8</td><td>6</td><td>61</td><td>183</td></tr><tr><td>2000032</td><td>12</td><td>5</td><td>103</td><td>309</td></tr><tr><td>2000033</td><td>13</td><td>5</td><td>94</td><td>282</td></tr><tr><td>2000034</td><td>10</td><td>5</td><td>51</td><td>153</td></tr><tr><td>2000035</td><td>11</td><td>4</td><td>68</td><td>204</td></tr><tr><td>2000036</td><td>6</td><td>5</td><td>37</td><td>111</td></tr><tr><td>2000037</td><td>7</td><td>4</td><td>46</td><td>138</td></tr><tr><td>2000038</td><td>9</td><td>4</td><td>102</td><td>306</td></tr><tr><td>2000039</td><td>12</td><td>6</td><td>58</td><td>174</td></tr><tr><td>2000040</td><td>13</td><td>6</td><td>80</td><td>240</td></tr><tr><td>2000041</td><td>8</td><td>5</td><td>44</td><td>132</td></tr><tr><td>2000042</td><td>8</td><td>4</td><td>85</td><td>255</td></tr><tr><td>2000043</td><td>8</td><td>5</td><td>40</td><td>120</td></tr><tr><td>2000044</td><td>8</td><td>5</td><td>44</td><td>132</td></tr><tr><td>2000045</td><td>9</td><td>4</td><td>88</td><td>264</td></tr><tr><td>2000046</td><td>8</td><td>3</td><td>32</td><td>96</td></tr><tr><td>2000047</td><td>5</td><td>3</td><td>20</td><td>60</td></tr><tr><td>2000048</td><td>3</td><td>3</td><td>14</td><td>42</td></tr><tr><td>2000049</td><td>13</td><td>5</td><td>68</td><td>204</td></tr><tr><td>2000050</td><td>7</td><td>4</td><td>33</td><td>99</td></tr><tr><td>2000051</td><td>8</td><td>5</td><td>59</td><td>177</td></tr><tr><td>2000052</td><td>16</td><td>6</td><td>63</td><td>189</td></tr><tr><td>2000053</td><td>14</td><td>6</td><td>90</td><td>270</td></tr><tr><td>2000054</td><td>10</td><td>4</td><td>76</td><td>228</td></tr><tr><td>2000055</td><td>14</td><td>6</td><td>90</td><td>270</td></tr><tr><td>2000056</td><td>12</td><td>5</td><td>63</td><td>189</td></tr><tr><td>2000057</td><td>13</td><td>6</td><td>135</td><td>405</td></tr><tr><td>2000058</td><td>10</td><td>5</td><td>46</td><td>138</td></tr><tr><td>2000059</td><td>6</td><td>5</td><td>61</td><td>183</td></tr><tr><td>2000060</td><td>7</td><td>3</td><td>49</td><td>147</td></tr><tr><td>2000061</td><td>16</td><td>6</td><td>112</td><td>336</td></tr><tr><td>2000062</td><td>12</td><td>6</td><td>89</td><td>267</td></tr><tr><td>2000063</td><td>7</td><td>4</td><td>55</td><td>165</td></tr><tr><td>2000064</td><td>12</td><td>5</td><td>105</td><td>315</td></tr><tr><td>2000065</td><td>16</td><td>6</td><td>86</td><td>258</td></tr><tr><td>2000066</td><td>16</td><td>6</td><td>74</td><td>222</td></tr><tr><td>2000067</td><td>12</td><td>6</td><td>138</td><td>414</td></tr><tr><td>2000068</td><td>9</td><td>4</td><td>47</td><td>141</td></tr><tr><td>2000069</td><td>10</td><td>5</td><td>58</td><td>174</td></tr><tr><td>2000070</td><td>12</td><td>5</td><td>56</td><td>168</td></tr><tr><td>2000071</td><td>9</td><td>4</td><td>40</td><td>120</td></tr><tr><td>2000072</td><td>10</td><td>6</td><td>56</td><td>168</td></tr><tr><td>2000073</td><td>9</td><td>4</td><td>93</td><td>279</td></tr><tr><td>2000074</td><td>16</td><td>6</td><td>120</td><td>360</td></tr><tr><td>2000075</td><td>13</td><td>5</td><td>126</td><td>378</td></tr><tr><td>2000076</td><td>13</td><td>6</td><td>63</td><td>189</td></tr><tr><td>2000077</td><td>8</td><td>5</td><td>59</td><td>177</td></tr><tr><td>2000078</td><td>9</td><td>5</td><td>57</td><td>171</td></tr><tr><td>2000079</td><td>13</td><td>5</td><td>95</td><td>285</td></tr><tr><td>2000080</td><td>12</td><td>6</td><td>63</td><td>189</td></tr><tr><td>2000081</td><td>7</td><td>4</td><td>19</td><td>57</td></tr><tr><td>2000082</td><td>14</td><td>6</td><td>141</td><td>423</td></tr><tr><td>2000083</td><td>15</td><td>6</td><td>97</td><td>291</td></tr><tr><td>2000084</td><td>14</td><td>6</td><td>109</td><td>327</td></tr><tr><td>2000085</td><td>9</td><td>5</td><td>55</td><td>165</td></tr><tr><td>2000086</td><td>12</td><td>6</td><td>51</td><td>153</td></tr><tr><td>2000087</td><td>4</td><td>4</td><td>18</td><td>54</td></tr><tr><td>2000088</td><td>9</td><td>6</td><td>58</td><td>174</td></tr><tr><td>2000089</td><td>9</td><td>5</td><td>78</td><td>234</td></tr><tr><td>2000090</td><td>15</td><td>6</td><td>84</td><td>252</td></tr><tr><td>2000091</td><td>15</td><td>4</td><td>82</td><td>246</td></tr><tr><td>2000092</td><td>10</td><td>4</td><td>73</td><td>219</td></tr><tr><td>2000093</td><td>7</td><td>4</td><td>49</td><td>147</td></tr><tr><td>2000094</td><td>15</td><td>4</td><td>77</td><td>231</td></tr><tr><td>2000095</td><td>11</td><td>5</td><td>118</td><td>354</td></tr><tr><td>2000096</td><td>3</td><td>2</td><td>25</td><td>75</td></tr><tr><td>2000097</td><td>13</td><td>5</td><td>83</td><td>249</td></tr><tr><td>2000098</td><td>12</td><td>5</td><td>55</td><td>165</td></tr><tr><td>2000099</td><td>14</td><td>6</td><td>107</td><td>321</td></tr><tr><td>2000100</td><td>11</td><td>5</td><td>49</td><td>147</td></tr><tr><td>2000101</td><td>10</td><td>5</td><td>59</td><td>177</td></tr><tr><td>2000102</td><td>10</td><td>6</td><td>81</td><td>243</td></tr><tr><td>2000103</td><td>6</td><td>4</td><td>22</td><td>66</td></tr><tr><td>2000104</td><td>10</td><td>6</td><td>106</td><td>318</td></tr><tr><td>2000105</td><td>11</td><td>6</td><td>48</td><td>144</td></tr><tr><td>2000106</td><td>14</td><td>6</td><td>86</td><td>258</td></tr><tr><td>2000107</td><td>9</td><td>6</td><td>80</td><td>240</td></tr><tr><td>2000108</td><td>15</td><td>6</td><td>114</td><td>342</td></tr><tr><td>2000109</td><td>15</td><td>4</td><td>67</td><td>201</td></tr><tr><td>2000110</td><td>7</td><td>4</td><td>42</td><td>126</td></tr><tr><td>2000111</td><td>9</td><td>5</td><td>116</td><td>348</td></tr><tr><td>2000112</td><td>20</td><td>6</td><td>224</td><td>672</td></tr><tr><td>2000113</td><td>11</td><td>5</td><td>59</td><td>177</td></tr><tr><td>2000114</td><td>12</td><td>6</td><td>58</td><td>174</td></tr><tr><td>2000115</td><td>10</td><td>4</td><td>54</td><td>162</td></tr><tr><td>2000116</td><td>8</td><td>5</td><td>78</td><td>234</td></tr><tr><td>2000117</td><td>13</td><td>6</td><td>52</td><td>156</td></tr><tr><td>2000118</td><td>15</td><td>6</td><td>99</td><td>297</td></tr><tr><td>2000119</td><td>7</td><td>3</td><td>38</td><td>114</td></tr><tr><td>2000120</td><td>12</td><td>5</td><td>118</td><td>354</td></tr><tr><td>2000121</td><td>14</td><td>6</td><td>69</td><td>207</td></tr><tr><td>2000122</td><td>7</td><td>4</td><td>65</td><td>195</td></tr><tr><td>2000123</td><td>10</td><td>6</td><td>74</td><td>222</td></tr><tr><td>2000124</td><td>6</td><td>4</td><td>31</td><td>93</td></tr><tr><td>2000125</td><td>10</td><td>6</td><td>45</td><td>135</td></tr><tr><td>2000126</td><td>9</td><td>6</td><td>47</td><td>141</td></tr><tr><td>2000127</td><td>13</td><td>6</td><td>69</td><td>207</td></tr><tr><td>2000128</td><td>17</td><td>5</td><td>110</td><td>330</td></tr><tr><td>2000129</td><td>8</td><td>4</td><td>44</td><td>132</td></tr><tr><td>2000130</td><td>11</td><td>5</td><td>52</td><td>156</td></tr><tr><td>2000131</td><td>13</td><td>6</td><td>83</td><td>249</td></tr><tr><td>2000132</td><td>13</td><td>5</td><td>93</td><td>279</td></tr><tr><td>2000133</td><td>10</td><td>5</td><td>64</td><td>192</td></tr><tr><td>2000134</td><td>12</td><td>6</td><td>173</td><td>519</td></tr><tr><td>2000135</td><td>9</td><td>5</td><td>59</td><td>177</td></tr><tr><td>2000136</td><td>12</td><td>6</td><td>92</td><td>276</td></tr><tr><td>2000137</td><td>16</td><td>5</td><td>95</td><td>285</td></tr><tr><td>2000138</td><td>7</td><td>3</td><td>44</td><td>132</td></tr><tr><td>2000139</td><td>9</td><td>6</td><td>86</td><td>258</td></tr><tr><td>2000140</td><td>10</td><td>6</td><td>51</td><td>153</td></tr><tr><td>2000141</td><td>12</td><td>4</td><td>103</td><td>309</td></tr><tr><td>2000142</td><td>12</td><td>6</td><td>54</td><td>162</td></tr><tr><td>2000143</td><td>9</td><td>4</td><td>39</td><td>117</td></tr><tr><td>2000144</td><td>8</td><td>5</td><td>26</td><td>78</td></tr><tr><td>2000145</td><td>9</td><td>4</td><td>54</td><td>162</td></tr><tr><td>2000146</td><td>7</td><td>5</td><td>76</td><td>228</td></tr><tr><td>2000147</td><td>10</td><td>4</td><td>57</td><td>171</td></tr><tr><td>2000148</td><td>10</td><td>6</td><td>66</td><td>198</td></tr><tr><td>2000149</td><td>12</td><td>6</td><td>78</td><td>234</td></tr><tr><td>2000150</td><td>9</td><td>6</td><td>97</td><td>291</td></tr><tr><td>2000151</td><td>13</td><td>5</td><td>51</td><td>153</td></tr><tr><td>2000152</td><td>8</td><td>5</td><td>54</td><td>162</td></tr><tr><td>2000153</td><td>9</td><td>5</td><td>49</td><td>147</td></tr><tr><td>2000154</td><td>11</td><td>6</td><td>68</td><td>204</td></tr><tr><td>2000155</td><td>13</td><td>6</td><td>97</td><td>291</td></tr><tr><td>2000156</td><td>17</td><td>6</td><td>93</td><td>279</td></tr><tr><td>2000157</td><td>11</td><td>4</td><td>66</td><td>198</td></tr><tr><td>2000158</td><td>13</td><td>6</td><td>96</td><td>288</td></tr><tr><td>2000159</td><td>13</td><td>5</td><td>84</td><td>252</td></tr><tr><td>2000160</td><td>13</td><td>5</td><td>89</td><td>267</td></tr><tr><td>2000161</td><td>10</td><td>3</td><td>55</td><td>165</td></tr><tr><td>2000162</td><td>13</td><td>5</td><td>87</td><td>261</td></tr><tr><td>2000163</td><td>13</td><td>6</td><td>68</td><td>204</td></tr><tr><td>2000164</td><td>5</td><td>4</td><td>44</td><td>132</td></tr><tr><td>2000165</td><td>8</td><td>4</td><td>47</td><td>141</td></tr><tr><td>2000166</td><td>12</td><td>6</td><td>63</td><td>189</td></tr><tr><td>2000167</td><td>12</td><td>6</td><td>71</td><td>213</td></tr><tr><td>2000168</td><td>8</td><td>3</td><td>42</td><td>126</td></tr><tr><td>2000169</td><td>12</td><td>6</td><td>77</td><td>231</td></tr><tr><td>2000170</td><td>14</td><td>5</td><td>104</td><td>312</td></tr><tr><td>2000171</td><td>11</td><td>5</td><td>71</td><td>213</td></tr><tr><td>2000172</td><td>13</td><td>6</td><td>120</td><td>360</td></tr><tr><td>2000173</td><td>16</td><td>6</td><td>146</td><td>438</td></tr><tr><td>2000174</td><td>8</td><td>4</td><td>38</td><td>114</td></tr><tr><td>2000175</td><td>8</td><td>4</td><td>68</td><td>204</td></tr><tr><td>2000176</td><td>8</td><td>4</td><td>81</td><td>243</td></tr><tr><td>2000177</td><td>12</td><td>6</td><td>66</td><td>198</td></tr><tr><td>2000178</td><td>12</td><td>4</td><td>100</td><td>300</td></tr><tr><td>2000179</td><td>11</td><td>5</td><td>150</td><td>450</td></tr><tr><td>2000180</td><td>5</td><td>3</td><td>19</td><td>57</td></tr><tr><td>2000181</td><td>12</td><td>5</td><td>100</td><td>300</td></tr><tr><td>2000182</td><td>11</td><td>4</td><td>66</td><td>198</td></tr><tr><td>2000183</td><td>10</td><td>6</td><td>64</td><td>192</td></tr><tr><td>2000184</td><td>10</td><td>4</td><td>54</td><td>162</td></tr><tr><td>2000185</td><td>7</td><td>6</td><td>36</td><td>108</td></tr><tr><td>2000186</td><td>15</td><td>6</td><td>94</td><td>282</td></tr><tr><td>2000187</td><td>12</td><td>6</td><td>55</td><td>165</td></tr><tr><td>2000188</td><td>10</td><td>5</td><td>49</td><td>147</td></tr><tr><td>2000189</td><td>16</td><td>6</td><td>90</td><td>270</td></tr><tr><td>2000190</td><td>11</td><td>5</td><td>66</td><td>198</td></tr><tr><td>2000191</td><td>14</td><td>4</td><td>93</td><td>279</td></tr><tr><td>2000192</td><td>8</td><td>3</td><td>48</td><td>144</td></tr><tr><td>2000193</td><td>14</td><td>4</td><td>111</td><td>333</td></tr><tr><td>2000194</td><td>11</td><td>4</td><td>59</td><td>177</td></tr><tr><td>2000195</td><td>11</td><td>5</td><td>89</td><td>267</td></tr><tr><td>2000196</td><td>10</td><td>5</td><td>64</td><td>192</td></tr><tr><td>2000197</td><td>8</td><td>4</td><td>45</td><td>135</td></tr><tr><td>2000198</td><td>8</td><td>5</td><td>57</td><td>171</td></tr><tr><td>2000199</td><td>11</td><td>6</td><td>53</td><td>159</td></tr><tr><td>2000200</td><td>10</td><td>5</td><td>38</td><td>114</td></tr><tr><td>2000201</td><td>11</td><td>6</td><td>69</td><td>207</td></tr><tr><td>2000202</td><td>12</td><td>5</td><td>129</td><td>387</td></tr><tr><td>2000203</td><td>16</td><td>6</td><td>105</td><td>315</td></tr><tr><td>2000204</td><td>6</td><td>4</td><td>30</td><td>90</td></tr><tr><td>2000205</td><td>17</td><td>6</td><td>130</td><td>390</td></tr><tr><td>2000206</td><td>13</td><td>5</td><td>98</td><td>294</td></tr><tr><td>2000207</td><td>10</td><td>4</td><td>118</td><td>354</td></tr><tr><td>2000208</td><td>14</td><td>5</td><td>82</td><td>246</td></tr><tr><td>2000209</td><td>12</td><td>4</td><td>99</td><td>297</td></tr><tr><td>2000210</td><td>12</td><td>5</td><td>74</td><td>222</td></tr><tr><td>2000211</td><td>9</td><td>6</td><td>60</td><td>180</td></tr><tr><td>2000212</td><td>11</td><td>6</td><td>66</td><td>198</td></tr><tr><td>2000213</td><td>19</td><td>6</td><td>96</td><td>288</td></tr><tr><td>2000214</td><td>10</td><td>6</td><td>89</td><td>267</td></tr><tr><td>2000215</td><td>14</td><td>6</td><td>104</td><td>312</td></tr><tr><td>2000216</td><td>14</td><td>6</td><td>71</td><td>213</td></tr><tr><td>2000217</td><td>10</td><td>4</td><td>58</td><td>174</td></tr><tr><td>2000218</td><td>15</td><td>6</td><td>126</td><td>378</td></tr><tr><td>2000219</td><td>10</td><td>5</td><td>81</td><td>243</td></tr><tr><td>2000220</td><td>10</td><td>4</td><td>43</td><td>129</td></tr><tr><td>2000221</td><td>10</td><td>5</td><td>61</td><td>183</td></tr><tr><td>2000222</td><td>8</td><td>4</td><td>37</td><td>111</td></tr><tr><td>2000223</td><td>11</td><td>6</td><td>46</td><td>138</td></tr><tr><td>2000224</td><td>12</td><td>6</td><td>48</td><td>144</td></tr><tr><td>2000225</td><td>11</td><td>5</td><td>71</td><td>213</td></tr><tr><td>2000226</td><td>8</td><td>5</td><td>70</td><td>210</td></tr><tr><td>2000227</td><td>12</td><td>6</td><td>69</td><td>207</td></tr><tr><td>2000228</td><td>14</td><td>5</td><td>70</td><td>210</td></tr><tr><td>2000229</td><td>16</td><td>5</td><td>150</td><td>450</td></tr><tr><td>2000230</td><td>15</td><td>6</td><td>84</td><td>252</td></tr><tr><td>2000231</td><td>12</td><td>5</td><td>63</td><td>189</td></tr><tr><td>2000232</td><td>11</td><td>5</td><td>64</td><td>192</td></tr><tr><td>2000233</td><td>11</td><td>5</td><td>85</td><td>255</td></tr><tr><td>2000234</td><td>12</td><td>6</td><td>61</td><td>183</td></tr><tr><td>2000235</td><td>5</td><td>3</td><td>32</td><td>96</td></tr><tr><td>2000236</td><td>10</td><td>5</td><td>44</td><td>132</td></tr><tr><td>2000237</td><td>10</td><td>6</td><td>139</td><td>417</td></tr><tr><td>2000238</td><td>9</td><td>4</td><td>54</td><td>162</td></tr><tr><td>2000239</td><td>17</td><td>6</td><td>77</td><td>231</td></tr><tr><td>2000240</td><td>8</td><td>4</td><td>53</td><td>159</td></tr><tr><td>2000241</td><td>14</td><td>6</td><td>86</td><td>258</td></tr><tr><td>2000242</td><td>11</td><td>4</td><td>49</td><td>147</td></tr><tr><td>2000243</td><td>9</td><td>6</td><td>108</td><td>324</td></tr><tr><td>2000244</td><td>7</td><td>4</td><td>30</td><td>90</td></tr><tr><td>2000245</td><td>8</td><td>5</td><td>56</td><td>168</td></tr><tr><td>2000246</td><td>11</td><td>6</td><td>89</td><td>267</td></tr><tr><td>2000247</td><td>16</td><td>5</td><td>100</td><td>300</td></tr><tr><td>2000248</td><td>13</td><td>5</td><td>166</td><td>498</td></tr><tr><td>2000249</td><td>13</td><td>6</td><td>121</td><td>363</td></tr><tr><td>2000250</td><td>10</td><td>5</td><td>79</td><td>237</td></tr><tr><td>2000251</td><td>11</td><td>5</td><td>89</td><td>267</td></tr><tr><td>2000252</td><td>10</td><td>4</td><td>64</td><td>192</td></tr><tr><td>2000253</td><td>15</td><td>6</td><td>76</td><td>228</td></tr><tr><td>2000254</td><td>10</td><td>5</td><td>78</td><td>234</td></tr><tr><td>2000255</td><td>11</td><td>5</td><td>69</td><td>207</td></tr><tr><td>2000256</td><td>6</td><td>4</td><td>21</td><td>63</td></tr><tr><td>2000257</td><td>8</td><td>4</td><td>47</td><td>141</td></tr><tr><td>2000258</td><td>7</td><td>5</td><td>34</td><td>102</td></tr><tr><td>2000259</td><td>6</td><td>5</td><td>40</td><td>120</td></tr><tr><td>2000260</td><td>9</td><td>5</td><td>43</td><td>129</td></tr><tr><td>2000261</td><td>10</td><td>4</td><td>64</td><td>192</td></tr><tr><td>2000262</td><td>16</td><td>6</td><td>121</td><td>363</td></tr><tr><td>2000263</td><td>14</td><td>5</td><td>106</td><td>318</td></tr><tr><td>2000264</td><td>11</td><td>5</td><td>99</td><td>297</td></tr><tr><td>2000265</td><td>13</td><td>5</td><td>67</td><td>201</td></tr><tr><td>2000266</td><td>11</td><td>6</td><td>74</td><td>222</td></tr><tr><td>2000267</td><td>7</td><td>5</td><td>38</td><td>114</td></tr><tr><td>2000268</td><td>10</td><td>4</td><td>76</td><td>228</td></tr><tr><td>2000269</td><td>11</td><td>6</td><td>62</td><td>186</td></tr><tr><td>2000270</td><td>9</td><td>5</td><td>92</td><td>276</td></tr><tr><td>2000271</td><td>9</td><td>5</td><td>54</td><td>162</td></tr><tr><td>2000272</td><td>8</td><td>5</td><td>69</td><td>207</td></tr><tr><td>2000273</td><td>11</td><td>6</td><td>78</td><td>234</td></tr><tr><td>2000274</td><td>9</td><td>6</td><td>57</td><td>171</td></tr><tr><td>2000275</td><td>19</td><td>6</td><td>155</td><td>465</td></tr><tr><td>2000276</td><td>12</td><td>5</td><td>55</td><td>165</td></tr><tr><td>2000277</td><td>12</td><td>5</td><td>50</td><td>150</td></tr><tr><td>2000278</td><td>7</td><td>5</td><td>41</td><td>123</td></tr><tr><td>2000279</td><td>10</td><td>5</td><td>40</td><td>120</td></tr><tr><td>2000280</td><td>11</td><td>5</td><td>48</td><td>144</td></tr><tr><td>2000281</td><td>4</td><td>4</td><td>16</td><td>48</td></tr><tr><td>2000282</td><td>15</td><td>4</td><td>104</td><td>312</td></tr><tr><td>2000283</td><td>8</td><td>5</td><td>44</td><td>132</td></tr><tr><td>2000284</td><td>10</td><td>6</td><td>51</td><td>153</td></tr><tr><td>2000285</td><td>10</td><td>6</td><td>89</td><td>267</td></tr><tr><td>2000286</td><td>7</td><td>5</td><td>38</td><td>114</td></tr><tr><td>2000287</td><td>12</td><td>5</td><td>61</td><td>183</td></tr><tr><td>2000288</td><td>18</td><td>5</td><td>96</td><td>288</td></tr><tr><td>2000289</td><td>7</td><td>4</td><td>96</td><td>288</td></tr><tr><td>2000290</td><td>14</td><td>5</td><td>80</td><td>240</td></tr><tr><td>2000291</td><td>14</td><td>6</td><td>98</td><td>294</td></tr><tr><td>2000292</td><td>9</td><td>4</td><td>52</td><td>156</td></tr><tr><td>2000293</td><td>12</td><td>5</td><td>80</td><td>240</td></tr><tr><td>2000294</td><td>10</td><td>6</td><td>81</td><td>243</td></tr><tr><td>2000295</td><td>14</td><td>5</td><td>99</td><td>297</td></tr><tr><td>2000296</td><td>15</td><td>6</td><td>91</td><td>273</td></tr><tr><td>2000297</td><td>10</td><td>6</td><td>81</td><td>243</td></tr><tr><td>2000298</td><td>12</td><td>4</td><td>99</td><td>297</td></tr><tr><td>2000299</td><td>5</td><td>3</td><td>29</td><td>87</td></tr></tbody></table></div>"
      ]
     },
     "metadata": {
      "application/vnd.databricks.v1+output": {
       "addedWidgets": {},
       "aggData": [],
       "aggError": "",
       "aggOverflow": false,
       "aggSchema": [],
       "aggSeriesLimitReached": false,
       "aggType": "",
       "arguments": {},
       "columnCustomDisplayInfos": {},
       "data": [
        [
         2000000,
         9,
         4,
         67,
         201
        ],
        [
         2000001,
         8,
         4,
         51,
         153
        ],
        [
         2000002,
         17,
         5,
         109,
         327
        ],
        [
         2000003,
         13,
         5,
         72,
         216
        ],
        [
         2000004,
         17,
         6,
         121,
         363
        ],
        [
         2000005,
         21,
         6,
         110,
         330
        ],
        [
         2000006,
         18,
         5,
         160,
         480
        ],
        [
         2000007,
         13,
         6,
         122,
         366
        ],
        [
         2000008,
         10,
         4,
         58,
         174
        ],
        [
         2000009,
         9,
         5,
         52,
         156
        ],
        [
         2000010,
         16,
         6,
         112,
         336
        ],
        [
         2000011,
         6,
         4,
         33,
         99
        ],
        [
         2000012,
         9,
         3,
         74,
         222
        ],
        [
         2000013,
         11,
         6,
         53,
         159
        ],
        [
         2000014,
         13,
         6,
         77,
         231
        ],
        [
         2000015,
         12,
         6,
         67,
         201
        ],
        [
         2000016,
         13,
         5,
         69,
         207
        ],
        [
         2000017,
         12,
         4,
         56,
         168
        ],
        [
         2000018,
         11,
         5,
         44,
         132
        ],
        [
         2000019,
         19,
         6,
         106,
         318
        ],
        [
         2000020,
         13,
         5,
         59,
         177
        ],
        [
         2000021,
         18,
         6,
         100,
         300
        ],
        [
         2000022,
         18,
         6,
         137,
         411
        ],
        [
         2000023,
         14,
         5,
         130,
         390
        ],
        [
         2000024,
         9,
         5,
         48,
         144
        ],
        [
         2000025,
         11,
         6,
         52,
         156
        ],
        [
         2000026,
         10,
         5,
         70,
         210
        ],
        [
         2000027,
         8,
         5,
         41,
         123
        ],
        [
         2000028,
         9,
         5,
         68,
         204
        ],
        [
         2000029,
         22,
         6,
         138,
         414
        ],
        [
         2000030,
         16,
         6,
         107,
         321
        ],
        [
         2000031,
         8,
         6,
         61,
         183
        ],
        [
         2000032,
         12,
         5,
         103,
         309
        ],
        [
         2000033,
         13,
         5,
         94,
         282
        ],
        [
         2000034,
         10,
         5,
         51,
         153
        ],
        [
         2000035,
         11,
         4,
         68,
         204
        ],
        [
         2000036,
         6,
         5,
         37,
         111
        ],
        [
         2000037,
         7,
         4,
         46,
         138
        ],
        [
         2000038,
         9,
         4,
         102,
         306
        ],
        [
         2000039,
         12,
         6,
         58,
         174
        ],
        [
         2000040,
         13,
         6,
         80,
         240
        ],
        [
         2000041,
         8,
         5,
         44,
         132
        ],
        [
         2000042,
         8,
         4,
         85,
         255
        ],
        [
         2000043,
         8,
         5,
         40,
         120
        ],
        [
         2000044,
         8,
         5,
         44,
         132
        ],
        [
         2000045,
         9,
         4,
         88,
         264
        ],
        [
         2000046,
         8,
         3,
         32,
         96
        ],
        [
         2000047,
         5,
         3,
         20,
         60
        ],
        [
         2000048,
         3,
         3,
         14,
         42
        ],
        [
         2000049,
         13,
         5,
         68,
         204
        ],
        [
         2000050,
         7,
         4,
         33,
         99
        ],
        [
         2000051,
         8,
         5,
         59,
         177
        ],
        [
         2000052,
         16,
         6,
         63,
         189
        ],
        [
         2000053,
         14,
         6,
         90,
         270
        ],
        [
         2000054,
         10,
         4,
         76,
         228
        ],
        [
         2000055,
         14,
         6,
         90,
         270
        ],
        [
         2000056,
         12,
         5,
         63,
         189
        ],
        [
         2000057,
         13,
         6,
         135,
         405
        ],
        [
         2000058,
         10,
         5,
         46,
         138
        ],
        [
         2000059,
         6,
         5,
         61,
         183
        ],
        [
         2000060,
         7,
         3,
         49,
         147
        ],
        [
         2000061,
         16,
         6,
         112,
         336
        ],
        [
         2000062,
         12,
         6,
         89,
         267
        ],
        [
         2000063,
         7,
         4,
         55,
         165
        ],
        [
         2000064,
         12,
         5,
         105,
         315
        ],
        [
         2000065,
         16,
         6,
         86,
         258
        ],
        [
         2000066,
         16,
         6,
         74,
         222
        ],
        [
         2000067,
         12,
         6,
         138,
         414
        ],
        [
         2000068,
         9,
         4,
         47,
         141
        ],
        [
         2000069,
         10,
         5,
         58,
         174
        ],
        [
         2000070,
         12,
         5,
         56,
         168
        ],
        [
         2000071,
         9,
         4,
         40,
         120
        ],
        [
         2000072,
         10,
         6,
         56,
         168
        ],
        [
         2000073,
         9,
         4,
         93,
         279
        ],
        [
         2000074,
         16,
         6,
         120,
         360
        ],
        [
         2000075,
         13,
         5,
         126,
         378
        ],
        [
         2000076,
         13,
         6,
         63,
         189
        ],
        [
         2000077,
         8,
         5,
         59,
         177
        ],
        [
         2000078,
         9,
         5,
         57,
         171
        ],
        [
         2000079,
         13,
         5,
         95,
         285
        ],
        [
         2000080,
         12,
         6,
         63,
         189
        ],
        [
         2000081,
         7,
         4,
         19,
         57
        ],
        [
         2000082,
         14,
         6,
         141,
         423
        ],
        [
         2000083,
         15,
         6,
         97,
         291
        ],
        [
         2000084,
         14,
         6,
         109,
         327
        ],
        [
         2000085,
         9,
         5,
         55,
         165
        ],
        [
         2000086,
         12,
         6,
         51,
         153
        ],
        [
         2000087,
         4,
         4,
         18,
         54
        ],
        [
         2000088,
         9,
         6,
         58,
         174
        ],
        [
         2000089,
         9,
         5,
         78,
         234
        ],
        [
         2000090,
         15,
         6,
         84,
         252
        ],
        [
         2000091,
         15,
         4,
         82,
         246
        ],
        [
         2000092,
         10,
         4,
         73,
         219
        ],
        [
         2000093,
         7,
         4,
         49,
         147
        ],
        [
         2000094,
         15,
         4,
         77,
         231
        ],
        [
         2000095,
         11,
         5,
         118,
         354
        ],
        [
         2000096,
         3,
         2,
         25,
         75
        ],
        [
         2000097,
         13,
         5,
         83,
         249
        ],
        [
         2000098,
         12,
         5,
         55,
         165
        ],
        [
         2000099,
         14,
         6,
         107,
         321
        ],
        [
         2000100,
         11,
         5,
         49,
         147
        ],
        [
         2000101,
         10,
         5,
         59,
         177
        ],
        [
         2000102,
         10,
         6,
         81,
         243
        ],
        [
         2000103,
         6,
         4,
         22,
         66
        ],
        [
         2000104,
         10,
         6,
         106,
         318
        ],
        [
         2000105,
         11,
         6,
         48,
         144
        ],
        [
         2000106,
         14,
         6,
         86,
         258
        ],
        [
         2000107,
         9,
         6,
         80,
         240
        ],
        [
         2000108,
         15,
         6,
         114,
         342
        ],
        [
         2000109,
         15,
         4,
         67,
         201
        ],
        [
         2000110,
         7,
         4,
         42,
         126
        ],
        [
         2000111,
         9,
         5,
         116,
         348
        ],
        [
         2000112,
         20,
         6,
         224,
         672
        ],
        [
         2000113,
         11,
         5,
         59,
         177
        ],
        [
         2000114,
         12,
         6,
         58,
         174
        ],
        [
         2000115,
         10,
         4,
         54,
         162
        ],
        [
         2000116,
         8,
         5,
         78,
         234
        ],
        [
         2000117,
         13,
         6,
         52,
         156
        ],
        [
         2000118,
         15,
         6,
         99,
         297
        ],
        [
         2000119,
         7,
         3,
         38,
         114
        ],
        [
         2000120,
         12,
         5,
         118,
         354
        ],
        [
         2000121,
         14,
         6,
         69,
         207
        ],
        [
         2000122,
         7,
         4,
         65,
         195
        ],
        [
         2000123,
         10,
         6,
         74,
         222
        ],
        [
         2000124,
         6,
         4,
         31,
         93
        ],
        [
         2000125,
         10,
         6,
         45,
         135
        ],
        [
         2000126,
         9,
         6,
         47,
         141
        ],
        [
         2000127,
         13,
         6,
         69,
         207
        ],
        [
         2000128,
         17,
         5,
         110,
         330
        ],
        [
         2000129,
         8,
         4,
         44,
         132
        ],
        [
         2000130,
         11,
         5,
         52,
         156
        ],
        [
         2000131,
         13,
         6,
         83,
         249
        ],
        [
         2000132,
         13,
         5,
         93,
         279
        ],
        [
         2000133,
         10,
         5,
         64,
         192
        ],
        [
         2000134,
         12,
         6,
         173,
         519
        ],
        [
         2000135,
         9,
         5,
         59,
         177
        ],
        [
         2000136,
         12,
         6,
         92,
         276
        ],
        [
         2000137,
         16,
         5,
         95,
         285
        ],
        [
         2000138,
         7,
         3,
         44,
         132
        ],
        [
         2000139,
         9,
         6,
         86,
         258
        ],
        [
         2000140,
         10,
         6,
         51,
         153
        ],
        [
         2000141,
         12,
         4,
         103,
         309
        ],
        [
         2000142,
         12,
         6,
         54,
         162
        ],
        [
         2000143,
         9,
         4,
         39,
         117
        ],
        [
         2000144,
         8,
         5,
         26,
         78
        ],
        [
         2000145,
         9,
         4,
         54,
         162
        ],
        [
         2000146,
         7,
         5,
         76,
         228
        ],
        [
         2000147,
         10,
         4,
         57,
         171
        ],
        [
         2000148,
         10,
         6,
         66,
         198
        ],
        [
         2000149,
         12,
         6,
         78,
         234
        ],
        [
         2000150,
         9,
         6,
         97,
         291
        ],
        [
         2000151,
         13,
         5,
         51,
         153
        ],
        [
         2000152,
         8,
         5,
         54,
         162
        ],
        [
         2000153,
         9,
         5,
         49,
         147
        ],
        [
         2000154,
         11,
         6,
         68,
         204
        ],
        [
         2000155,
         13,
         6,
         97,
         291
        ],
        [
         2000156,
         17,
         6,
         93,
         279
        ],
        [
         2000157,
         11,
         4,
         66,
         198
        ],
        [
         2000158,
         13,
         6,
         96,
         288
        ],
        [
         2000159,
         13,
         5,
         84,
         252
        ],
        [
         2000160,
         13,
         5,
         89,
         267
        ],
        [
         2000161,
         10,
         3,
         55,
         165
        ],
        [
         2000162,
         13,
         5,
         87,
         261
        ],
        [
         2000163,
         13,
         6,
         68,
         204
        ],
        [
         2000164,
         5,
         4,
         44,
         132
        ],
        [
         2000165,
         8,
         4,
         47,
         141
        ],
        [
         2000166,
         12,
         6,
         63,
         189
        ],
        [
         2000167,
         12,
         6,
         71,
         213
        ],
        [
         2000168,
         8,
         3,
         42,
         126
        ],
        [
         2000169,
         12,
         6,
         77,
         231
        ],
        [
         2000170,
         14,
         5,
         104,
         312
        ],
        [
         2000171,
         11,
         5,
         71,
         213
        ],
        [
         2000172,
         13,
         6,
         120,
         360
        ],
        [
         2000173,
         16,
         6,
         146,
         438
        ],
        [
         2000174,
         8,
         4,
         38,
         114
        ],
        [
         2000175,
         8,
         4,
         68,
         204
        ],
        [
         2000176,
         8,
         4,
         81,
         243
        ],
        [
         2000177,
         12,
         6,
         66,
         198
        ],
        [
         2000178,
         12,
         4,
         100,
         300
        ],
        [
         2000179,
         11,
         5,
         150,
         450
        ],
        [
         2000180,
         5,
         3,
         19,
         57
        ],
        [
         2000181,
         12,
         5,
         100,
         300
        ],
        [
         2000182,
         11,
         4,
         66,
         198
        ],
        [
         2000183,
         10,
         6,
         64,
         192
        ],
        [
         2000184,
         10,
         4,
         54,
         162
        ],
        [
         2000185,
         7,
         6,
         36,
         108
        ],
        [
         2000186,
         15,
         6,
         94,
         282
        ],
        [
         2000187,
         12,
         6,
         55,
         165
        ],
        [
         2000188,
         10,
         5,
         49,
         147
        ],
        [
         2000189,
         16,
         6,
         90,
         270
        ],
        [
         2000190,
         11,
         5,
         66,
         198
        ],
        [
         2000191,
         14,
         4,
         93,
         279
        ],
        [
         2000192,
         8,
         3,
         48,
         144
        ],
        [
         2000193,
         14,
         4,
         111,
         333
        ],
        [
         2000194,
         11,
         4,
         59,
         177
        ],
        [
         2000195,
         11,
         5,
         89,
         267
        ],
        [
         2000196,
         10,
         5,
         64,
         192
        ],
        [
         2000197,
         8,
         4,
         45,
         135
        ],
        [
         2000198,
         8,
         5,
         57,
         171
        ],
        [
         2000199,
         11,
         6,
         53,
         159
        ],
        [
         2000200,
         10,
         5,
         38,
         114
        ],
        [
         2000201,
         11,
         6,
         69,
         207
        ],
        [
         2000202,
         12,
         5,
         129,
         387
        ],
        [
         2000203,
         16,
         6,
         105,
         315
        ],
        [
         2000204,
         6,
         4,
         30,
         90
        ],
        [
         2000205,
         17,
         6,
         130,
         390
        ],
        [
         2000206,
         13,
         5,
         98,
         294
        ],
        [
         2000207,
         10,
         4,
         118,
         354
        ],
        [
         2000208,
         14,
         5,
         82,
         246
        ],
        [
         2000209,
         12,
         4,
         99,
         297
        ],
        [
         2000210,
         12,
         5,
         74,
         222
        ],
        [
         2000211,
         9,
         6,
         60,
         180
        ],
        [
         2000212,
         11,
         6,
         66,
         198
        ],
        [
         2000213,
         19,
         6,
         96,
         288
        ],
        [
         2000214,
         10,
         6,
         89,
         267
        ],
        [
         2000215,
         14,
         6,
         104,
         312
        ],
        [
         2000216,
         14,
         6,
         71,
         213
        ],
        [
         2000217,
         10,
         4,
         58,
         174
        ],
        [
         2000218,
         15,
         6,
         126,
         378
        ],
        [
         2000219,
         10,
         5,
         81,
         243
        ],
        [
         2000220,
         10,
         4,
         43,
         129
        ],
        [
         2000221,
         10,
         5,
         61,
         183
        ],
        [
         2000222,
         8,
         4,
         37,
         111
        ],
        [
         2000223,
         11,
         6,
         46,
         138
        ],
        [
         2000224,
         12,
         6,
         48,
         144
        ],
        [
         2000225,
         11,
         5,
         71,
         213
        ],
        [
         2000226,
         8,
         5,
         70,
         210
        ],
        [
         2000227,
         12,
         6,
         69,
         207
        ],
        [
         2000228,
         14,
         5,
         70,
         210
        ],
        [
         2000229,
         16,
         5,
         150,
         450
        ],
        [
         2000230,
         15,
         6,
         84,
         252
        ],
        [
         2000231,
         12,
         5,
         63,
         189
        ],
        [
         2000232,
         11,
         5,
         64,
         192
        ],
        [
         2000233,
         11,
         5,
         85,
         255
        ],
        [
         2000234,
         12,
         6,
         61,
         183
        ],
        [
         2000235,
         5,
         3,
         32,
         96
        ],
        [
         2000236,
         10,
         5,
         44,
         132
        ],
        [
         2000237,
         10,
         6,
         139,
         417
        ],
        [
         2000238,
         9,
         4,
         54,
         162
        ],
        [
         2000239,
         17,
         6,
         77,
         231
        ],
        [
         2000240,
         8,
         4,
         53,
         159
        ],
        [
         2000241,
         14,
         6,
         86,
         258
        ],
        [
         2000242,
         11,
         4,
         49,
         147
        ],
        [
         2000243,
         9,
         6,
         108,
         324
        ],
        [
         2000244,
         7,
         4,
         30,
         90
        ],
        [
         2000245,
         8,
         5,
         56,
         168
        ],
        [
         2000246,
         11,
         6,
         89,
         267
        ],
        [
         2000247,
         16,
         5,
         100,
         300
        ],
        [
         2000248,
         13,
         5,
         166,
         498
        ],
        [
         2000249,
         13,
         6,
         121,
         363
        ],
        [
         2000250,
         10,
         5,
         79,
         237
        ],
        [
         2000251,
         11,
         5,
         89,
         267
        ],
        [
         2000252,
         10,
         4,
         64,
         192
        ],
        [
         2000253,
         15,
         6,
         76,
         228
        ],
        [
         2000254,
         10,
         5,
         78,
         234
        ],
        [
         2000255,
         11,
         5,
         69,
         207
        ],
        [
         2000256,
         6,
         4,
         21,
         63
        ],
        [
         2000257,
         8,
         4,
         47,
         141
        ],
        [
         2000258,
         7,
         5,
         34,
         102
        ],
        [
         2000259,
         6,
         5,
         40,
         120
        ],
        [
         2000260,
         9,
         5,
         43,
         129
        ],
        [
         2000261,
         10,
         4,
         64,
         192
        ],
        [
         2000262,
         16,
         6,
         121,
         363
        ],
        [
         2000263,
         14,
         5,
         106,
         318
        ],
        [
         2000264,
         11,
         5,
         99,
         297
        ],
        [
         2000265,
         13,
         5,
         67,
         201
        ],
        [
         2000266,
         11,
         6,
         74,
         222
        ],
        [
         2000267,
         7,
         5,
         38,
         114
        ],
        [
         2000268,
         10,
         4,
         76,
         228
        ],
        [
         2000269,
         11,
         6,
         62,
         186
        ],
        [
         2000270,
         9,
         5,
         92,
         276
        ],
        [
         2000271,
         9,
         5,
         54,
         162
        ],
        [
         2000272,
         8,
         5,
         69,
         207
        ],
        [
         2000273,
         11,
         6,
         78,
         234
        ],
        [
         2000274,
         9,
         6,
         57,
         171
        ],
        [
         2000275,
         19,
         6,
         155,
         465
        ],
        [
         2000276,
         12,
         5,
         55,
         165
        ],
        [
         2000277,
         12,
         5,
         50,
         150
        ],
        [
         2000278,
         7,
         5,
         41,
         123
        ],
        [
         2000279,
         10,
         5,
         40,
         120
        ],
        [
         2000280,
         11,
         5,
         48,
         144
        ],
        [
         2000281,
         4,
         4,
         16,
         48
        ],
        [
         2000282,
         15,
         4,
         104,
         312
        ],
        [
         2000283,
         8,
         5,
         44,
         132
        ],
        [
         2000284,
         10,
         6,
         51,
         153
        ],
        [
         2000285,
         10,
         6,
         89,
         267
        ],
        [
         2000286,
         7,
         5,
         38,
         114
        ],
        [
         2000287,
         12,
         5,
         61,
         183
        ],
        [
         2000288,
         18,
         5,
         96,
         288
        ],
        [
         2000289,
         7,
         4,
         96,
         288
        ],
        [
         2000290,
         14,
         5,
         80,
         240
        ],
        [
         2000291,
         14,
         6,
         98,
         294
        ],
        [
         2000292,
         9,
         4,
         52,
         156
        ],
        [
         2000293,
         12,
         5,
         80,
         240
        ],
        [
         2000294,
         10,
         6,
         81,
         243
        ],
        [
         2000295,
         14,
         5,
         99,
         297
        ],
        [
         2000296,
         15,
         6,
         91,
         273
        ],
        [
         2000297,
         10,
         6,
         81,
         243
        ],
        [
         2000298,
         12,
         4,
         99,
         297
        ],
        [
         2000299,
         5,
         3,
         29,
         87
        ]
       ],
       "datasetInfos": [
        {
         "name": "_sqldf",
         "schema": {
          "fields": [
           {
            "metadata": {},
            "name": "customerID",
            "nullable": true,
            "type": "long"
           },
           {
            "metadata": {},
            "name": "total_purchases",
            "nullable": false,
            "type": "long"
           },
           {
            "metadata": {},
            "name": "unique_products_bought",
            "nullable": false,
            "type": "long"
           },
           {
            "metadata": {},
            "name": "total_products_bought",
            "nullable": true,
            "type": "long"
           },
           {
            "metadata": {},
            "name": "total_spent",
            "nullable": true,
            "type": "long"
           }
          ],
          "type": "struct"
         },
         "tableIdentifier": null,
         "typeStr": "pyspark.sql.connect.dataframe.DataFrame"
        }
       ],
       "dbfsResultPath": null,
       "isJsonSchema": true,
       "metadata": {
        "createTempViewForImplicitDf": true,
        "dataframeName": "_sqldf",
        "executionCount": 17
       },
       "overflow": false,
       "plotOptions": {
        "customPlotOptions": {},
        "displayType": "table",
        "pivotAggregation": null,
        "pivotColumns": null,
        "xColumns": null,
        "yColumns": null
       },
       "removedWidgets": [],
       "schema": [
        {
         "metadata": "{}",
         "name": "customerID",
         "type": "\"long\""
        },
        {
         "metadata": "{}",
         "name": "total_purchases",
         "type": "\"long\""
        },
        {
         "metadata": "{}",
         "name": "unique_products_bought",
         "type": "\"long\""
        },
        {
         "metadata": "{}",
         "name": "total_products_bought",
         "type": "\"long\""
        },
        {
         "metadata": "{}",
         "name": "total_spent",
         "type": "\"long\""
        }
       ],
       "type": "table"
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "SELECT *\n",
    "FROM data_by_customer;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "application/vnd.databricks.v1+cell": {
     "cellMetadata": {
      "byteLimit": 2048000,
      "rowLimit": 10000
     },
     "finishTime": 1783608334946,
     "inputWidgets": {},
     "nuid": "8219181b-23d3-4acf-92ca-5f32cc65634f",
     "showTitle": false,
     "startTime": 1783608330728,
     "submitTime": 1783608270122,
     "tableResultSettingsMap": {},
     "title": ""
    }
   },
   "outputs": [],
   "source": [
    "-- DDL 3\n",
    "-- Data for each Unique Product\n",
    "\n",
    "CREATE OR REPLACE VIEW data_by_product AS\n",
    "SELECT product,\n",
    "  COUNT(DISTINCT(transactionID)) AS total_times_bought,\n",
    "  COUNT(DISTINCT(paymentMethod)) AS total_payment_methods,\n",
    "  SUM(quantity) AS total_quantity_bought,\n",
    "  AVG(unitPrice) AS avg_spent_per_unit,\n",
    "  SUM(totalPrice) AS total_spent\n",
    "FROM customer_data\n",
    "GROUP BY product;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "application/vnd.databricks.v1+cell": {
     "cellMetadata": {
      "byteLimit": 2048000,
      "rowLimit": 10000
     },
     "finishTime": 1783609026258,
     "inputWidgets": {},
     "nuid": "102d021c-3b8c-4082-b815-0dbfefd8c335",
     "showTitle": false,
     "startTime": 1783609023399,
     "submitTime": 1783609023364,
     "tableResultSettingsMap": {},
     "title": ""
    }
   },
   "outputs": [],
   "source": [
    "-- DDL 4\n",
    "-- Rolling Window Date-by-Date KPI\n",
    "-- Window Functions + Common Table Expressions (CTEs)\n",
    "--- [Subqueries and especially JOINs have been quite in-demand; let's see if we'll have to use them here again like in my other projects]\n",
    "\n",
    "CREATE OR REPLACE VIEW kpi_earnings_per_day AS\n",
    "WITH daily_data AS (\n",
    "  SELECT\n",
    "    LEFT(dateTime, 10) AS date,\n",
    "    franchiseID,\n",
    "    SUM(totalPrice)  AS total_earnings,\n",
    "    SUM(unitPrice)   AS total_earnings_per_unit,\n",
    "    AVG(quantity)    AS avg_quantity_bought\n",
    "  FROM customer_data\n",
    "  GROUP BY franchiseID, LEFT(dateTime, 10)\n",
    "),\n",
    "with_lag AS (\n",
    "  SELECT\n",
    "    franchiseID,\n",
    "    date,\n",
    "    total_earnings,\n",
    "    LAG(total_earnings) OVER (PARTITION BY franchiseID ORDER BY date) AS prev_total_earnings,\n",
    "    total_earnings_per_unit,\n",
    "    LAG(total_earnings_per_unit) OVER (PARTITION BY franchiseID ORDER BY date) AS prev_total_earnings_per_unit,\n",
    "    avg_quantity_bought,\n",
    "    LAG(avg_quantity_bought) OVER (PARTITION BY franchiseID ORDER BY date) AS prev_avg_quantity_bought\n",
    "  FROM daily_data\n",
    ")\n",
    "SELECT\n",
    "  franchiseID,\n",
    "  date,\n",
    "  total_earnings,\n",
    "    ROUND((total_earnings - prev_total_earnings)\n",
    "    / NULLIF(prev_total_earnings, 0) * 100, 2) AS pct_change_earnings_per_day,\n",
    "\n",
    "  total_earnings_per_unit,\n",
    "  ROUND((total_earnings_per_unit - prev_total_earnings_per_unit)\n",
    "    / NULLIF(prev_total_earnings_per_unit, 0) * 100, 2) AS pct_change_total_earnings_per_unit_per_day,\n",
    "\n",
    "  avg_quantity_bought,\n",
    "  ROUND((avg_quantity_bought - prev_avg_quantity_bought)\n",
    "    / NULLIF(prev_avg_quantity_bought, 0) * 100, 2) AS pct_change_avg_quantity_bought_per_day\n",
    "FROM with_lag\n",
    "ORDER BY franchiseID, date;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "application/vnd.databricks.v1+cell": {
     "cellMetadata": {
      "byteLimit": 2048000,
      "rowLimit": 10000
     },
     "finishTime": 1783609067736,
     "height": "156",
     "inputWidgets": {},
     "nuid": "e3851de8-ad6c-42f4-9c2b-22994e1653ed",
     "showTitle": false,
     "startTime": 1783609061328,
     "submitTime": 1783609061286,
     "tableResultSettingsMap": {},
     "title": "",
     "width": "1006"
    }
   },
   "outputs": [
    {
     "output_type": "display_data",
     "data": {
      "text/html": [
       "<style scoped>\n",
       "  .table-result-container {\n",
       "    max-height: 300px;\n",
       "    overflow: auto;\n",
       "  }\n",
       "  table, th, td {\n",
       "    border: 1px solid black;\n",
       "    border-collapse: collapse;\n",
       "  }\n",
       "  th, td {\n",
       "    padding: 5px;\n",
       "  }\n",
       "  th {\n",
       "    text-align: left;\n",
       "  }\n",
       "</style><div class='table-result-container'><table class='table-result'><thead style='background-color: white'><tr><th>num_affected_rows</th><th>num_inserted_rows</th></tr></thead><tbody></tbody></table></div>"
      ]
     },
     "metadata": {
      "application/vnd.databricks.v1+output": {
       "addedWidgets": {},
       "aggData": [],
       "aggError": "",
       "aggOverflow": false,
       "aggSchema": [],
       "aggSeriesLimitReached": false,
       "aggType": "",
       "arguments": {},
       "columnCustomDisplayInfos": {},
       "data": [],
       "datasetInfos": [
        {
         "name": "_sqldf",
         "schema": {
          "fields": [
           {
            "metadata": {},
            "name": "num_affected_rows",
            "nullable": true,
            "type": "long"
           },
           {
            "metadata": {},
            "name": "num_inserted_rows",
            "nullable": true,
            "type": "long"
           }
          ],
          "type": "struct"
         },
         "tableIdentifier": null,
         "typeStr": "pyspark.sql.connect.dataframe.DataFrame"
        }
       ],
       "dbfsResultPath": null,
       "isJsonSchema": true,
       "metadata": {
        "createTempViewForImplicitDf": true,
        "dataframeName": "_sqldf",
        "executionCount": 27
       },
       "overflow": false,
       "plotOptions": {
        "customPlotOptions": {},
        "displayType": "table",
        "pivotAggregation": null,
        "pivotColumns": null,
        "xColumns": null,
        "yColumns": null
       },
       "removedWidgets": [],
       "schema": [
        {
         "metadata": "{}",
         "name": "num_affected_rows",
         "type": "\"long\""
        },
        {
         "metadata": "{}",
         "name": "num_inserted_rows",
         "type": "\"long\""
        }
       ],
       "type": "table"
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "-- DDL 5!\n",
    "-- GOLD LAYER / ML FEATURE STORE\n",
    "-- Enterprise Customer Churn Prediction Dataset\n",
    "-- CTEs, Aggregations, Nested Subqueries, Feature Engineering for Future ML and MLOps\n",
    "\n",
    "CREATE OR REPLACE TABLE gold_ml_customer_features AS\n",
    "\n",
    "WITH customer_metrics AS (\n",
    "\n",
    "SELECT\n",
    "    customerID,\n",
    "    COUNT(transactionID)                                   AS total_transactions,\n",
    "    SUM(TotalPrice)                                        AS lifetime_spend,\n",
    "    ROUND(AVG(TotalPrice), 2)                              AS avg_transaction_value,\n",
    "    ROUND(AVG(unitPrice), 2)                               AS avg_unit_price,\n",
    "    SUM(quantity)                                          AS total_items,\n",
    "    ROUND(AVG(quantity), 2)                                AS avg_items_per_transaction,\n",
    "    COUNT(DISTINCT product)                                AS unique_products,\n",
    "    COUNT(DISTINCT franchiseID)                            AS unique_franchises,\n",
    "    COUNT(DISTINCT paymentMethod)                          AS payment_method_diversity,\n",
    "    MIN(dateTime)                                          AS first_purchase,\n",
    "    MAX(dateTime)                                          AS last_purchase,\n",
    "    NTILE(5) OVER (ORDER BY SUM(TotalPrice) DESC)          AS customer_value_quintile,\n",
    "    DATEDIFF(CURRENT_DATE(), MAX(dateTime))\n",
    "        AS recency_days,\n",
    "    DATEDIFF(MAX(dateTime), MIN(dateTime))\n",
    "        AS customer_lifetime_days,\n",
    "    ROUND( DATEDIFF(MAX(dateTime), MIN(dateTime))\n",
    "        / NULLIF(COUNT(transactionID)-1, 0), 2)\n",
    "        AS avg_days_between_purchases,\n",
    "    COUNT(DISTINCT DATE(dateTime))\n",
    "        AS active_days,\n",
    "    COUNT(DISTINCT DATE_TRUNC('month', dateTime))\n",
    "        AS active_months\n",
    "FROM customer_data\n",
    "GROUP BY customerID\n",
    ")\n",
    "\n",
    "SELECT\n",
    "  customerID,\n",
    "  customer_value_quintile,\n",
    "  total_transactions,\n",
    "  lifetime_spend,\n",
    "  avg_transaction_value,\n",
    "  avg_unit_price,\n",
    "  total_items,\n",
    "  avg_items_per_transaction,\n",
    "  unique_products,\n",
    "  unique_franchises,\n",
    "  payment_method_diversity,\n",
    "  first_purchase,\n",
    "  last_purchase,\n",
    "  recency_days,\n",
    "  customer_lifetime_days,\n",
    "  avg_days_between_purchases,\n",
    "  active_days,\n",
    "  active_months,\n",
    "  ROUND(\n",
    "    lifetime_spend /\n",
    "    NULLIF(total_transactions,0),2\n",
    "  ) AS revenue_per_order,\n",
    "  ROUND(\n",
    "    total_items /\n",
    "    NULLIF(total_transactions,0),2\n",
    "  ) AS avg_basket_size,\n",
    "  ROUND(\n",
    "    lifetime_spend /\n",
    "    NULLIF(active_months,0),2\n",
    "  ) AS avg_monthly_spend,\n",
    "CASE\n",
    "  WHEN unique_franchises > 1\n",
    "  THEN 1\n",
    "  ELSE 0\n",
    "  END AS multi_franchise_customer,\n",
    "CASE\n",
    "  WHEN lifetime_spend >\n",
    "  (\n",
    "    SELECT AVG(customer_spend)\n",
    "    FROM\n",
    "    (\n",
    "      SELECT\n",
    "      SUM(TotalPrice) AS customer_spend\n",
    "      FROM customer_data\n",
    "      GROUP BY customerID\n",
    "    )\n",
    "  )\n",
    "  THEN 1\n",
    "  ELSE 0\n",
    "END AS high_value_customer,\n",
    "\n",
    "CASE\n",
    "  WHEN recency_days >= 90\n",
    "  THEN 1\n",
    "  ELSE 0\n",
    "END AS churn_label\n",
    "FROM customer_metrics\n",
    "ORDER BY customerID;"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "application/vnd.databricks.v1+cell": {
     "cellMetadata": {
      "byteLimit": 2048000,
      "rowLimit": 10000
     },
     "finishTime": 1783608384195,
     "inputWidgets": {},
     "nuid": "fbd4f218-b96a-4706-9f5c-93aae5a0a165",
     "showTitle": true,
     "startTime": 1783608358068,
     "submitTime": 1783608270127,
     "tableResultSettingsMap": {},
     "title": "Cell 7"
    }
   },
   "outputs": [
    {
     "output_type": "stream",
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "All tables exported successfully!\n"
     ]
    }
   ],
   "source": [
    "%python\n",
    "# Using PySpark to store all Created SQL Tables for Future Analyses\n",
    "\n",
    "# Read views from the default schema\n",
    "bydate = spark.read.table(\"default.data_by_date\")\n",
    "bycustomer = spark.read.table(\"default.data_by_customer\")\n",
    "byproduct = spark.read.table(\"default.data_by_product\")\n",
    "kpis = spark.read.table(\"default.kpi_earnings_per_day\")\n",
    "goldml = spark.read.table(\"default.gold_ml_customer_features\")\n",
    "\n",
    "# Save each DataFrame as a Delta table (Unity Catalog workspace requires this)\n",
    "bydate.write.mode(\"overwrite\").saveAsTable(\"default.data_by_date_export\")\n",
    "bycustomer.write.mode(\"overwrite\").saveAsTable(\"default.data_by_customer_export\")\n",
    "byproduct.write.mode(\"overwrite\").saveAsTable(\"default.data_by_product_export\")\n",
    "kpis.write.mode(\"overwrite\").saveAsTable(\"default.kpi_earnings_per_day_export\")\n",
    "goldml.write.mode(\"overwrite\").saveAsTable(\"default.gold_ml_customer_features_export\")\n",
    "\n",
    "print(\"All tables exported successfully!\")"
   ]
  }
 ],
 "metadata": {
  "application/vnd.databricks.v1+notebook": {
   "computePreferences": null,
   "dashboards": [],
   "environmentMetadata": null,
   "inputWidgetPreferences": null,
   "language": "sql",
   "notebookMetadata": {
    "mostRecentlyExecutedCommandWithImplicitDF": {
     "commandId": -1,
     "dataframes": [
      "_sqldf"
     ]
    },
    "pythonIndentUnit": 2
   },
   "notebookName": "1-data_eng_creation",
   "widgets": {}
  },
  "language_info": {
   "name": "sql"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 0
}