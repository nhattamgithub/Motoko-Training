import React from "react";
import { Link } from "react-router-dom";

const Home = () => {
  return (
    <>
      <p>HELLO Home</p>
      <Link to="/test-use-callback">Go to test use callback</Link>
    </>
  )
}

export default Home;