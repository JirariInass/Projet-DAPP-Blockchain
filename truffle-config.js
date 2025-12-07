module.exports = {
  networks: {
    development: {
      host: "127.0.0.1", // Localhost (default: none)
      port: 7545,       // <-- CHANGEZ 8545 PAR 7545
      network_id: "*",  // Any network (default: none)
    },
  },
  
  // ... (le reste du fichier reste inchangé)
  
  contracts_build_directory: "./src/artifacts/", 
  compilers: {
    solc: {
      optimizer: {
        enabled: false,
        runs: 200
      },
      version: "0.8.21", // Cette version est celle qui a compilé avec succès
      evmVersion: "byzantium"
    }
  }
};