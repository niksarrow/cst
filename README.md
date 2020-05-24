# IWSLT Conversational Fluent Translation Tast 2020
This repository contains the implementation of encoder-decoder_aux-decoder architecture adapted from facebookresearch/UnsupervisedMT.

## Experiments and Data
https://docs.google.com/spreadsheets/d/1EUY2BeXVBp7RDZ-sIo9ImYc1tY9yFXCsDLGXg4BW8Xs/edit?usp=sharing

## The Implementation includes:
- Autoencoder Training
- Parallel Data Training
- Parallel Auxiliary Data Traning (via aux decoder)

## Noise Model Techniques for Disfluency Removal:
- Synonym Insertion
- Filler Word Insertion/Repetition
- Small Phrase Repetition
- Word Shuffle
- Word Dropout
- Random Word Insertion
- Word Blank

## Dependencies

* Python 3
* [NumPy](http://www.numpy.org/)
* [PyTorch](http://pytorch.org/) 
* [Moses](http://www.statmt.org/moses/) (clean and tokenize text / train PBSMT model)
* [fastBPE](https://github.com/glample/fastBPE) (generate and apply BPE codes)
* [fastText](https://github.com/facebookresearch/fastText) (generate embeddings)
* [MUSE](https://github.com/facebookresearch/MUSE) (generate cross-lingual embeddings)

## References

### Unsupervised Machine Translation With Monolingual Data Only

[2] G. Lample, A. Conneau, L. Denoyer, MA. Ranzato [*Unsupervised Machine Translation With Monolingual Data Only*](https://arxiv.org/abs/1711.00043)

```
@inproceedings{lample2017unsupervised,
  title = {Unsupervised machine translation using monolingual corpora only},
  author = {Lample, Guillaume and Conneau, Alexis and Denoyer, Ludovic and Ranzato, Marc'Aurelio},
  booktitle = {International Conference on Learning Representations (ICLR)},
  year = {2018}
}
```

### Word Translation Without Parallel Data

[3] A. Conneau\*, G. Lample\*, L. Denoyer, MA. Ranzato, H. Jégou, [*Word Translation Without Parallel Data*](https://arxiv.org/pdf/1710.04087.pdf)

\* Equal contribution. Order has been determined with a coin flip.
```
@inproceedings{conneau2017word,
  title = {Word Translation Without Parallel Data},
  author = {Conneau, Alexis and Lample, Guillaume and Ranzato, Marc'Aurelio and Denoyer, Ludovic and J\'egou, Herv\'e},
  booktitle = {International Conference on Learning Representations (ICLR)},
  year = {2018}
}
```

### Fluent Translations from Disfluent Speech in End-to-End Speech Translation

[1] Elizabeth Salesky, Matthias Sperber, Alex Waibel
```
@inproceedings{Salesky2019FluentTF,
  title={Fluent Translations from Disfluent Speech in End-to-End Speech Translation},
  author={Elizabeth Salesky and Matthias Sperber and Alex H. Waibel},
  booktitle={NAACL-HLT},
  year={2019}
}
```
