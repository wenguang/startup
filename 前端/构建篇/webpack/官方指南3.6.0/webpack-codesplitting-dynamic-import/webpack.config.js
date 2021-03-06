const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
// const webpack = require('webpack');
// const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
    entry: {
        app: './src/index.js'
    },
    output: {
        filename: '[name].bundle.js',
        // https://doc.webpack-china.org/configuration/output/#output-chunkfilename
        chunkFilename: '[name].bundle.js',
        // chunkFilename: '[id].[chunkhash].bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    plugins: [
        new CleanWebpackPlugin(['dist']),
        new HtmlWebpackPlugin({
            title: '代码分离——动态引入'
        })
        // new webpack.optimize.CommonsChunkPlugin({
        //     name: 'common' //指定公共bundle名称
        // }),
        // new ExtractTextPlugin("style.css")
    ],
    module: {
        rules: [
            { test: /\.css$/, use: ['style-loader', 'css-loader'] },
            // {
            //     test: /\.css$/,
            //     use: ExtractTextPlugin.extract({
            //         fallback: "style-loader",
            //         use: "css-loader"
            //     })
            // },
            { test: /\.(png|svg|jpg|jpeg|gif)$/, use: ['file-loader'] },
            { test: /\.(woff|woff2|eot|ttf|otf)$/, use: ['file-loader'] },
            { test: /\.(csv|tsv)$/, use: ['csv-loader'] },
            { test: /\.xml$/, use: ['xml-loader'] }
        ]
    }
};