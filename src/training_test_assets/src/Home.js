import React from "react";
import { Link } from "react-router-dom";
import './App.css';
const Home = () => {
  return (
    <>
      <p>HELLO Home</p>
      <Link to="/test-use-callback"><p>Go to test use callback</p></Link>
      <Link to="/test-use-memo"><p>Go to test use memo</p></Link>
    </>
  )
}

export default Home;