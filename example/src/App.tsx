import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import TrtcVoiceRoom from 'react-native-trtc-voice-room';


export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    TrtcVoiceRoom.closeSeat(1,true);
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
