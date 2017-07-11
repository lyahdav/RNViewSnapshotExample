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
  Alert,
  ScrollView,
  Picker,
  Slider,
  Switch,
  NativeModules
} from 'react-native';
import FlatListDemo from "./FlatListDemo";

function pausecomp(millis) {
  var date = new Date();
  var curDate = null;
  do { curDate = new Date(); }
  while (curDate - date < millis);
}

var didSleep = false;

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

  state = {
    language: "js",
    switchState: false
  }

  render() {
    if (!didSleep) {
      console.log('begin sleep');
      pausecomp(5000);
      console.log('finished sleep');
      const ViewSnapshotter = NativeModules.ViewSnapshotter;
      ViewSnapshotter.didStartJsRendering();
      didSleep = true;
    }
    return (

      <ScrollView style={styles.container} automaticallyAdjustContentInsets={false}>
        {/*<FlatListDemo />*/}
        <Text style={styles.text}>Line 1</Text>
        <Text style={styles.text}>Line 2</Text>
        <Text style={styles.text}>Line 3</Text>
        <Picker selectedValue={this.state.language} onValueChange={(itemValue, itemIndex) => this.setState({language: itemValue})}>
          <Picker.Item
                    label="n/a"
            value={null}
            key={0}
                />
          <Picker.Item label="Java" value="java" key={1} />
          <Picker.Item label="JavaScript" value="js" key={2} />
        </Picker>
        <Slider/>
        <Button
          onPress={this.onButtonPress}
          title="Show alert"
        />
        <Text style={styles.text}>Line 4</Text>
        <Text style={styles.text}>Line 5</Text>
        <Text style={styles.text}>Line 6</Text>
        <Switch style={styles.switch} value={this.state.switchState} onValueChange={(itemValue) => this.setState({switchState: itemValue})} />
        <Text style={styles.text}>Line 7</Text>
        <Text style={styles.text}>Line 8</Text>
        <Text style={styles.text}>Line 9</Text>
        <Text style={styles.text}>Line 10</Text>
        <Text style={styles.text}>Line 11</Text>
        <Text style={styles.text}>Line 12</Text>
      </ScrollView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    marginTop: 60,
    flex: 1,
    backgroundColor: '#F5FCFF'
  },
  switch: {
    margin: 30
  },
  text: {
    marginTop: 10
  }
});

AppRegistry.registerComponent('RNViewSnapshotExample', () => RNViewSnapshotExample);
