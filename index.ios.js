/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button,
  NativeModules
} from 'react-native';

export default class RNViewSnapshotExample extends Component {
  onPressPrintSnapshot() {
    const ViewSnapshotter = NativeModules.ViewSnapshotter;
    ViewSnapshotter.printSnapshot();
  }

  onPressSaveSnapshot() {
    const ViewSnapshotter = NativeModules.ViewSnapshotter;
    ViewSnapshotter.saveSnapshot();
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!2
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
        <Button
          onPress={this.onPressPrintSnapshot}
          title="Print Snapshot"
        />
        <Button
          onPress={this.onPressSaveSnapshot}
          title="Save Snapshot"
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('RNViewSnapshotExample', () => RNViewSnapshotExample);
