
# IWSLT Conversational Fluent Translation Tast 2020
This repository contains the implementation of encoder-decoder_aux-decoder architecture adapted from facebookresearch/UnsupervisedMT. This was a submission to IWSLT 2020 Conversational Disfluency Removal Task.

## The Implementation includes:
- Autoencoder Training
- Parallel Data Training

## Noise Model Techniques for Disfluency Removal:
- Synonym Insertion
- Filler Word Insertion/Repetition
- Small Phrase Repetition
- Pronoun Phrase Repetition
- False Start
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

## Data
Download data in spanish and english. Create a data directory. Create sub-directories according to get_data_esen_noise.sh and place data accordingly. 

## Data Preparation

    ./get_data_esen.sh

## References

### Unsupervised Machine Translation With Monolingual Data Only

[1] G. Lample, A. Conneau, L. Denoyer, MA. Ranzato [*Unsupervised Machine Translation With Monolingual Data Only*](https://arxiv.org/abs/1711.00043)

```
@inproceedings{lample2017unsupervised,
  title = {Unsupervised machine translation using monolingual corpora only},
  author = {Lample, Guillaume and Conneau, Alexis and Denoyer, Ludovic and Ranzato, Marc'Aurelio},
  booktitle = {International Conference on Learning Representations (ICLR)},
  year = {2018}
}
```

### Word Translation Without Parallel Data

[2] A. Conneau\*, G. Lample\*, L. Denoyer, MA. Ranzato, H. Jégou, [*Word Translation Without Parallel Data*](https://arxiv.org/pdf/1710.04087.pdf)

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

[3] Elizabeth Salesky, Matthias Sperber, Alex Waibel
```
@inproceedings{Salesky2019FluentTF,
  title={Fluent Translations from Disfluent Speech in End-to-End Speech Translation},
  author={Elizabeth Salesky and Matthias Sperber and Alex H. Waibel},
  booktitle={NAACL-HLT},
  year={2019}
}
```
### Findings of the IWSLT 2020 Evaluation Campaign

[4] Ebrahim Ansari and Amittai Axelrod and Nguyen Bach and Ondrej Bojar and Roldano Cattoni and Fahim Dalvi and Nadir Durrani and Marcello Federico and Christian Federmann and Jiatao Gu and Fei Huang and Kevin Knight and Xutai Ma and Ajay Nagesh and Matteo Negri and Jan Niehues and Juan Pino and Elizabeth Salesky and Xing Shi and Sebastian St\"uker and Marco Turchi and Changhan Wang
```
@inproceedings{iwslt:2020,  
Address = {Seattle, USA},  
Author = {Ebrahim Ansari and Amittai Axelrod and Nguyen Bach and Ondrej Bojar and Roldano Cattoni and Fahim Dalvi and Nadir Durrani and Marcello Federico and Christian Federmann and Jiatao Gu and Fei Huang and Kevin Knight and Xutai Ma and Ajay Nagesh and Matteo Negri and Jan Niehues and Juan Pino and Elizabeth Salesky and Xing Shi and Sebastian St\"uker and Marco Turchi and Changhan Wang},  
Booktitle = {Proceedings of the 17th International Conference on Spoken Language Translation (IWSLT 2020)},  
Keywords = {IWSLT},  
Title = {{Findings of the IWSLT 2020 Evaluation Campaign}},  
Year = {2020}  
}
```
## Contact

> Nikhil Saini
> Email : niksarrow196@gmail.com, nikhilra@cse.iitb.ac.in
> Department of Computer Science & Engineering 
> Indian Institute of Technology, Bombay
