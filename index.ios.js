/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  View,
  Text
} from 'react-native';
import FlatListDemo from "./FlatListDemo";

export default class RNViewSnapshotExample extends Component {
  render() {
    return (
      <View style={styles.container}>
        {/*<FlatListDemo />*/}
        <Text>foo</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'stretch',
    backgroundColor: '#F5FCFF',
  }
});

AppRegistry.registerComponent('RNViewSnapshotExample', () => RNViewSnapshotExample);
