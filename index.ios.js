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
  Text,
  Button,
  Alert
} from 'react-native';
import FlatListDemo from "./FlatListDemo";

function pausecomp(millis)
{
    var date = new Date();
    var curDate = null;
    do { curDate = new Date(); }
    while(curDate-date < millis);
}

export default class RNViewSnapshotExample extends Component {
  onButtonPress() {
    Alert.alert(
      'Alert Title',
      'Alert Message',
      [
        { text: 'OK', onPress: () => console.log('OK Pressed') },
      ],
      { cancelable: false }
    );
  }

  render() {
    pausecomp(5000);
    return (

      <View style={styles.container}>
        {/*<FlatListDemo />*/}
        <Text>This is text</Text>
        <Button
          onPress={this.onButtonPress}
          title="Show alert"
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
  }
});

AppRegistry.registerComponent('RNViewSnapshotExample', () => RNViewSnapshotExample);
