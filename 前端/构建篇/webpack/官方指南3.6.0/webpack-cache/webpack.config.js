const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const webpack = require('webpack');
// const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
    entry: {
        app: './src/index.js',
        vendor1: [
            'lodash'
        ],
        vendor2: [
            'underscore'
        ]
    },
    output: {
        filename: '[name].[chunkhash].js',
        chunkFilename: '[name].[chunkhash].js',
        path: path.resolve(__dirname, 'dist')
    },
    plugins: [
        new CleanWebpackPlugin(['dist']),
        new HtmlWebpackPlugin({
            title: '缓存'
        }),
        new webpack.HashedModuleIdsPlugin(),
        // vendor一定要在runtime之前，不然会报错
        new webpack.optimize.CommonsChunkPlugin({
            names: ["vendor2", "vendor1"]
        }),
        // 分开写会报错：ERROR in CommonsChunkPlugin: While running in normal mode it's not allowed to use a non-entry chunk (vendor2)
        // https://github.com/webpack/webpack/issues/1016
        // new webpack.optimize.CommonsChunkPlugin({
        //     name: 'vendor2'
        // }),
        new webpack.optimize.CommonsChunkPlugin({
            name: 'webpackBootstrap'
        })
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